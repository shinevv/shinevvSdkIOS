#ifndef MEDIA_SOUP_DEVICE_H
#define MEDIA_SOUP_DEVICE_H

#include <string>
#include "handles/Handler.h"

class Device {
public:

	Device(RoomCallBack* room_call_back);
	~Device();

	std::string Flag();

	std::string Name();

	std::string Version();

	std::string Bowser();

	bool isSupported() {
		return true;
	}

	AntiWeb* GetHandler();
private:

	std::string _flag = "PC_flag";

	std::string _name = "PC_name";

	std::string _version = "1.0";

	std::string _browser = "PC_browser";

//	Handler*	_handler = NULL;
	AntiWeb*	_anti_web = NULL;
};













#endif
