#include <iostream>
#include <thread>
#include <core/utils/commands.hpp>
#include <features/domain/entities/boat_credential.hpp>
#include <features/data/dataends/remote_data_end.hpp>
#include <features/data/repos/info_sender_repo_impl.hpp>
#include <features/domain/entities/actuator_info.hpp>


using std::shared_ptr;
using std::make_shared;

int main(){
    BoatCredential credentials{"0x0001", "test", "test"};
    shared_ptr<HttpSendClient> httpSendClient = make_shared<HttpSendClient>();
    shared_ptr<RemoteDataEndImpl> remoteEnd = make_shared<RemoteDataEndImpl>(httpSendClient);

    shared_ptr<InfoSenderRepo> repository = make_shared<InfoSenderRepoImpl>(credentials, remoteEnd);

    // GetConcreteNumberTrivia getConcreteNumberTrivia(repository);
    // GetRandomNumberTrivia getRandomNumberTrivia(repository);

    std::
    while(true){
        auto response = repository->sendHighPowerBatteryInfo(HighPowerBatteryInfo());

        if(response.has_value()){
            auto val = *response;
            std::cout << "Sent: " << val.getResponse() << std::endl;
        }else{
            std::cout << "error: " << std::endl;
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }
}