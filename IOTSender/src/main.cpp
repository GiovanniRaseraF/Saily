#include <iostream>

#include <features/data/repos/number_trivia_repo_impl.hpp>

#include <features/domain/entities/actuator_info.hpp>

#include <features/domain/usecases/get_concrete_number_trivia.hpp>
#include <features/domain/usecases/get_random_number_trivia.hpp>

using std::shared_ptr;
using std::make_shared;

int main(){
    shared_ptr<ConnectionTester> tester = make_shared<ConnectionTester>();
    shared_ptr<NetworkInfo> net = make_shared<NetworkInfo>(tester);

    SharedPreferences prefs("shared_prefes.db");
    shared_ptr<LocalDataSourceImpl> local 
        = make_shared<LocalDataSourceImpl>(prefs);
    shared_ptr<HttpClient> http = make_shared<HttpClient>();
    shared_ptr<RemoteDataSourceImpl> remote 
        = make_shared<RemoteDataSourceImpl>(http);

    shared_ptr<NumberTriviaRepoImpl> repository 
        = make_shared<NumberTriviaRepoImpl>(net, local, remote);

    GetConcreteNumberTrivia getConcreteNumberTrivia(repository);
    GetRandomNumberTrivia getRandomNumberTrivia(repository);

    int i = 0;
    while(true){
        int number = i++;

        auto concrete = getConcreteNumberTrivia.call(number);

        std::cout << NumberTriviaModel(concrete.number, concrete.text).toJsonString() << std::endl;

        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }
}