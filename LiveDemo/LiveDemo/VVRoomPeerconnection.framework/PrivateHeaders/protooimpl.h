#ifndef SHINEVV_PROTOO_IMPL_H
#define SHINEVV_PROTOO_IMPL_H

#include "protoo.h"
#include "webrtc/base/thread.h"
#include "webrtc/base/thread.h"
#include "webrtc/base/json.h"
#include "webrtc/base/common.h"
#include "webrtc/system_wrappers/include/critical_section_wrapper.h"
#include "webrtc/modules/utility/include/process_thread.h"
#include "webrtc/modules/include/module.h"

#include "kmapi.h"
#include "util/util.h"
#include <map>
#include <vector>
#include <future>
#include <functional>
#include <thread>


using namespace kuma;

const char kMethodName[] = "method";
const char kData[] = "data";
const char kRequest[] = "request";

#define PROTOCL "protoo"

typedef struct _ProcessCallBackStruct {
public:
	_ProcessCallBackStruct(void* user_data, ProcessCallBack successCallBack, ProcessCallBack failCallBack)
		: _user_data(user_data)
		, _successCallBack(successCallBack)
		, _failCallBack(failCallBack) {}
	void* _user_data = NULL;
	ProcessCallBack _successCallBack = NULL;
	ProcessCallBack _failCallBack = NULL;
}ProcessCallBackStruct;


typedef std::map<int64_t , ProcessCallBackStruct> ProcessCallBackMap;
typedef std::pair<int64_t, ProcessCallBackStruct> ProcessCallBackMapPair;

class ProtooClientImpl : public ProtooClient{
public:
	ProtooClientImpl(ProtooRecvRequestCallBack* callBack);
	virtual ~ProtooClientImpl();

	/// impl ProtooClient
	virtual void ConnectionRequest(std::string serverIP, int serverPort, int timeout_ms
			, std::string token, std::string roomId, std::string peerName, std::string role, std::string displayName) override;
	virtual void Disconnect() override;

	virtual void Send(std::string data, ProcessCallBack successCallBack
			, ProcessCallBack failCallBack, void* userdata, bool notify) override;
	virtual void Send(std::string data, ProcessCallBack successCallBack
			, ProcessCallBack failCallBack, void* userdata, std::string method) override;
private:
	void Accept(int message_id);
	void onSend(KMError err);
	void onData(KMBuffer &buf);

private:
	bool loop_inited_;
	EventLoop*  loop_ = new EventLoop(PollType::NONE);
	WebSocket*  ws_;
	//WebSocket*  web_socket_;
	ProtooRecvRequestCallBack* _callBack;
	bool ws_connected_;

	ProcessCallBackMap _process_call_back_map;
	std::thread _kuma_std_thread;
};

extern uint64_t GetRandom();









#endif