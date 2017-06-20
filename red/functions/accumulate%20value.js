//node.warn(util.inspect(msg));



if (msg.payload === undefined) {
    node.warn('nope');
    return;
}
if (typeof(msg.payload) == "object") {
    //node.warn(msg);
    context.set('options', msg.payload);
    return;
}

var options = context.get('options')||{min:0, max:100};
var value = context.get(  'value');
if (isNaN(value)) { 
    value = options.min + (options.max-options.min)/2;
}
//node.log("previous value: "+value)
//node.log("delta: "+msg.payload)
if (options.maxdelta && msg.payload > options.maxdelta) { msg.payload = options.maxdelta; }
value += msg.payload;
if (value > options.max) { value = options.max }
if (value < options.min) { value = options.min }
context.set('value', value);
msg.payload = Math.round(value);
if (options.topic) { msg.topic = options.topic; }

//node.log("Value now "+msg.payload);
node.status({text:msg.payload});
return msg;
