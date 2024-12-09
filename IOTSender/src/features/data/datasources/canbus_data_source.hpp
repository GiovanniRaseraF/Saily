#pragma once
#include <fstream>
#include <vector>
#include <net/if.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <linux/can.h>
#include <linux/can/raw.h>

#include <core/utils/shared_preferences.hpp>
#include <core/iterfaces/observer.hpp>

class CanBusDataSource : public Subject<can_frame>{
    CanBusDataSource(){}
};