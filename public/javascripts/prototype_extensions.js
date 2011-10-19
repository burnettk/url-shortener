Event.observeOnce = function(el, eventName, callback) {
  var wrappedCallback = function(event){
    Event.stopObserving(el, eventName, wrappedCallback);
    callback(event);
  };
  Event.observe(el, eventName, wrappedCallback);
  return wrappedCallback;
};

$E = function(selector){
  return $$(selector)[0];
};
