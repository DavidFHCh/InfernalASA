class Stupid inherits Dumb {
  int a = 0;
  boolean b;

  int f(int a, int b){
    b = true;
    b = false;
    a = 0;
    switch(a){
      case 0:
        a = 0;
        break;
      default:
    };
    return a;
  }
}
