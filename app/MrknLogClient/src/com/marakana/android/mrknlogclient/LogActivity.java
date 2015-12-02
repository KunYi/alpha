
package com.marakana.android.mrknlogclient;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.marakana.android.service.log.LogListener;
import com.marakana.android.service.log.LogManager;

public class LogActivity extends Activity implements OnClickListener, LogListener {

  private static final String FLUSH_LOG =
      "com.marakana.android.logservice.FLUSH_LOG";

  private TextView output;

  private final LogManager logManager = LogManager.getInstance();

  private final int totalLogSize = this.logManager.getTotalLogSize();

  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    super.setContentView(R.layout.log);
    this.output = (TextView)super.findViewById(R.id.output);
    Button button = (Button)super.findViewById(R.id.button);
    button.setOnClickListener(this);
  }

  private void updateOutput(int usedLogSize) {
    this.output.setText(super.getString(R.string.log_utilization_message,
      usedLogSize, this.totalLogSize));
  }

  @Override
  public void onResume() {
    super.onResume();
    this.logManager.register(this);
    this.updateOutput(this.logManager.getUsedLogSize());
  }

  @Override
  public void onPause() {
    super.onPause();
    this.logManager.unregister(this);
  }

  @Override
  public void onClick(View view) {
    //Verify the FLUSH_LOG permission
    if (checkSelfPermission(FLUSH_LOG)
        != PackageManager.PERMISSION_GRANTED) {
      //Ask the user for permission
      requestPermissions(new String[]{FLUSH_LOG}, 0);
    } else {
      //We already have permission
      flushLog();
    }
  }

  @Override
  public void onRequestPermissionsResult(int requestCode,
      String permissions[], int[] grantResults) {
    // If request is cancelled, the result arrays are empty.
    if (grantResults.length > 0
        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
      //Permission was granted
      flushLog();
    }
  }

  private void flushLog() {
    this.logManager.flushLog();
    this.updateOutput(0);
  }

  @Override
  public void onUsedLogSizeChange(int usedLogSize) {
    this.updateOutput(usedLogSize);
  }
}
