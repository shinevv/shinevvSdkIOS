#ifndef SHINEVV_PROTOO_H
#define SHINEVV_PROTOO_H

#include <string>

typedef void* (*ProcessCallBack)(std::string data,void* userdata);

class ProtooRecvRequestCallBack {
public:
	virtual ~ProtooRecvRequestCallBack() {}
	virtual void OnProtooConnected(int code) = 0;
	virtual void OnProtooDisConnected() = 0;
	virtual void RecvData(std::string recMethod, std::string data) = 0;
};

class RoomClient;

class ProtooClient {
public:
	static ProtooClient* Create(ProtooRecvRequestCallBack* closeSuccessCallBack);
	static void Destroy(ProtooClient*);

	virtual void ConnectionRequest(std::string serverIP ,int serverPort, int timeout_ms
			, std::string token, std::string roomId, std::string peerName, std::string role, std::string displayName) = 0;
	virtual void Disconnect() = 0;

	virtual void Send(std::string data, ProcessCallBack successCallBack
			, ProcessCallBack failCallBack, void* userdata, bool notify = false) = 0;
	virtual void Send(std::string data, ProcessCallBack successCallBack
			, ProcessCallBack failCallBack, void* userdata, std::string method) = 0;

protected:
	virtual ~ProtooClient() {}
};


#endif