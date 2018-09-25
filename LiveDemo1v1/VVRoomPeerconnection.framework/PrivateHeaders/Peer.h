#ifndef MEDIA_SOUP_PEER_H
#define MEDIA_SOUP_PEER_H

#include "base/BaseClass.h"
#include "mediasoup/Consumer.h"
#include <map>

typedef std::map<int, Consumer*> ConsumerMap;
typedef std::pair<int, Consumer*> ConsumerPair;

class Peer : public Consumer::Listener{
public:
	class Listener {
	public:
		virtual ~Listener(){}
		virtual bool NewConsumer(Consumer* consumer) = 0;
	};

	Peer(std::string peerName,std::string displayName, std::string role, Listener* listener);
	virtual ~Peer();

	bool AddConsumer(Consumer* consumer);

	ConsumerMap& GetConsumers() {
		return _consumers;
	}

	Consumer* GetConsumer(int64_t id);

	std::string GetPeerName() {
		return _peerName;
	}

	void RemoveConsumer(int64_t id);

	std::string GetDisplayName() {
		return _displayName;
	}

	std::string GetRole() {
		return _role;
	}

	virtual void Close(int64_t id) override;
	virtual void Close(int64_t id, std::string originator) override {}
private:
	std::string _peerName;

	std::string _displayName;

	std::string _role;

	bool _cloesd = false;

	ConsumerMap _consumers;

	Listener* _listener = NULL;
};
#endif