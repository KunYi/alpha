#define LOG_NDEBUG 0                                               /* <1> */
#define LOG_FILE "/dev/log/main"                                   /* <2> */
#define LOG_TAG "MrknLog"                                          /* <1> */
#define LOG_ID LOG_ID_MAIN

#include <mrknlog.h>                                               /* <3> */                                         /* <4> */
#include <fcntl.h>
#include <poll.h>                                                  /* <5> */
#include <errno.h>
#include <sys/ioctl.h>                                             /* <5> */

static int flush_log(struct mrknlog_device_t* dev) {
  SLOGV("Flushing %s", LOG_FILE);                                  /* <1> */
  struct logger *logger = android_logger_open(dev->logger_list, LOG_ID);
  return android_logger_clear(logger);
}

static int get_total_log_size(struct mrknlog_device_t* dev) {
  SLOGV("Getting total buffer size of %s", LOG_FILE);              /* <1> */
  struct logger *logger = android_logger_open(dev->logger_list, LOG_ID);
  return android_logger_get_log_size(logger);
}

static int get_used_log_size(struct mrknlog_device_t* dev) {
  SLOGV("Getting used buffer size of %s", LOG_FILE);               /* <1> */
  struct logger *logger = android_logger_open(dev->logger_list, LOG_ID);
  return android_logger_get_log_readable_size(logger);
}

static int wait_for_log_data(struct mrknlog_device_t* dev, int timeout) {
  SLOGV("Waiting for log data on %s with timeout=%d", 
    LOG_FILE, timeout); /* <1> */
  int ret;
  
  /* consume all of the available data */
  struct log_msg log_msg;
  int new_data_counter = 0;
  while(1) {
    /* we have to read because the file is not seekable */
    ret = android_logger_list_read(dev->logger_list, &log_msg);
    if (ret < 0) {
      SLOGE("Failed to read %s: %s", LOG_FILE, strerror(errno)); /* <1> */
      return -1;
    } else if (ret == 0) {
      SLOGE("Unexpected EOF on reading %s", LOG_FILE);           /* <1> */
      return -1;
    } else {
      new_data_counter += ret;
      /* check to see if there is more data to read */
      ret = android_logger_list_read(dev->logger_list, &log_msg);/* <4> */
      if (ret < 0) {
        SLOGE("Failed to get next entry len on %s: %s",          /* <1> */
          LOG_FILE, strerror(errno)); 
        return -1;
      } else if (ret == 0) { /* no more data; we are done */
        SLOGV("Got %d / %d / %d on %s", new_data_counter,        /* <1> */
          get_used_log_size(dev), get_total_log_size(dev), LOG_FILE);
        return new_data_counter;
      }
    } 
  }
}

static int close_mrknlog(struct mrknlog_device_t* dev) {
  SLOGV("Closing %s", LOG_FILE);
  if (dev) {
    //android_logger_close(dev->logger);                                                /* <5> */
    free(dev);                                                     /* <6> */
    dev = 0;
  }
  return 0;
}

static int open_mrknlog(const struct hw_module_t *module, char const *name,
   struct hw_device_t **device) {

  pid_t pid = getpid();
  struct logger_list *logger_list = android_logger_list_open(LOG_ID,
      O_RDONLY | O_NDELAY, 1000, pid);

  if (!logger_list) {
    SLOGE("Failed to open %s: %s", LOG_FILE, strerror(errno));
    return -1;
  } else {
    struct mrknlog_device_t *dev =                                 /* <3> */
      malloc(sizeof(struct mrknlog_device_t));                     /* <6> */
    if (!dev) {
      return -ENOMEM;
    }
    SLOGV("Opened %s", LOG_FILE);                                  /* <1> */
    memset(dev, 0, sizeof(*dev));                                  /* <6> */
    dev->common.tag = HARDWARE_DEVICE_TAG;                         /* <6> */
    dev->common.version = 0;                                       /* <6> */
    dev->common.module = (struct hw_module_t *)module;             /* <6> */
    dev->common.close =                                            /* <7> */
      (int (*)(struct hw_device_t *)) close_mrknlog;
    dev->logger_list = logger_list;                                                  /* <6> */
    dev->flush_log = flush_log;                                    /* <7> */
    dev->get_total_log_size = get_total_log_size;                  /* <7> */
    dev->get_used_log_size = get_used_log_size;                    /* <7> */
    dev->wait_for_log_data = wait_for_log_data;                    /* <7> */
    *device = (struct hw_device_t *)dev;
    return 0;
  }
}

static struct hw_module_methods_t mrknlog_module_methods = {
  .open = open_mrknlog,                                            /* <7> */
};

struct hw_module_t HAL_MODULE_INFO_SYM = {                         /* <8> */
  .tag = HARDWARE_MODULE_TAG,
  .version_major = 1,
  .version_minor = 0,
  .id = MRKNLOG_HARDWARE_MODULE_ID,                                /* <3> */
  .name = "mrknlog module",
  .author = "NewCircle, Inc.",
  .methods = &mrknlog_module_methods,                              /* <7> */
};
