ArrayList a = new ArrayList();
a.add(123);
a.add(34.43);
a.add("sdfs");
a.add(false);

println(a);

int b = (Integer)a.get(0);
float c = (Float)a.get(1);
String d = (String)a.get(2);
boolean e = (Boolean)a.get(3);

println(d);
