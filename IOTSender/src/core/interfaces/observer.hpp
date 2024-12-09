#pragma once

template <typename T>
class Observer{
 public:
  virtual ~IObserver(){};
  virtual void Update(const T &message_from_subject) = 0;
};

template <typename T>
class Subject {
 public:
  virtual ~ISubject(){};
  virtual void Attach(IObserver<T> *observer) = 0;
  virtual void Detach(IObserver<T> *observer) = 0;
  virtual void Notify() = 0;
};