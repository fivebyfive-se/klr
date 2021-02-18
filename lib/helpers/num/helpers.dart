
/// Linear interpolation: get value between `x` and `y`
/// at the ratio `a`. 
double lerp(num x, num y, double a)
  => x * (1.0 - a) + y * a;
