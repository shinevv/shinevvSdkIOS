#ifndef BUILD_URL_H
#define BUILD_URL_H

#include <string>
#include <time.h>
#include <future>
#include <functional>
#include <chrono>
#include "webrtc/base/json.h"
#include "webrtc/base/common.h"
#include "webrtc/system_wrappers/include/critical_section_wrapper.h"
#include "webrtc/modules/utility/include/process_thread.h"
#include "webrtc/modules/include/module.h"
#include "webrtc/base/logging.h"
#include "webrtc/base/helpers.h"

#define CameraId 0

extern uint64_t GetRandom();

typedef struct _ROOM_OPTIONS {
public:
	_ROOM_OPTIONS() {}
	_ROOM_OPTIONS(int requestTimeout, bool transportOptions) :_requestTimeout(requestTimeout), _transportOptions(transportOptions) {}
	int					_requestTimeout = 10000;
	bool				_transportOptions = false;
	void*	_roomSettings = NULL;
	void*				_turnServers = NULL;
}ROOM_OPTIONS;

typedef struct _CAN_SEND_BY_KIND {
public:
	_CAN_SEND_BY_KIND() {}
	_CAN_SEND_BY_KIND(bool video, bool audio) :_video(video), _audio(audio) {}
	bool _video = false;
	bool _audio = false;
}CAN_SEND_BY_KIND;

typedef struct _AppData {
public:
	_AppData(void* handler, std::promise<Json::Value>& prom)
		:_handler(handler), _prom(std::ref(prom)) {}
	void* _handler = NULL;
	std::promise<Json::Value>& _prom;
}AppData;

typedef struct _ConsumerInfos {
public:
	_ConsumerInfos(std::string kind, std::string trackId, uint64_t ssrc, uint64_t rtx_ssrc, std::string cname)
		: _kind(kind)
		, _trackId(trackId)
		, _ssrc(ssrc)
		, _rtx_ssrc(rtx_ssrc)
		, _cname(cname) {}
	std::string _kind;
	std::string _trackId;
	uint64_t _ssrc = 0;
	uint64_t _rtx_ssrc = 0;
	std::string _cname;
}ConsumerInfos;

#endif 
