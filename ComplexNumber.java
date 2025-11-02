
class ComplexNumber
{
  private float a , b ;
  
  public ComplexNumber(float a , float b)
  {
    this.a = a; this.b = b;
  }
  public ComplexNumber()
  {
    this(0,0);
  }
  
  public ComplexNumber add(ComplexNumber z)
  {
    float a = getReal() + z.getReal() ;
    float b = getImaginary() + z.getImaginary();
    
    this.a = a; this.b = b;
    
    return this;
  }
  public ComplexNumber sub(ComplexNumber z)
  {
    float a = getReal() - z.getReal() ;
    float b = getImaginary() - z.getImaginary();
    
    this.a = a ; this.b = b;
    
    return this;
  }
  public ComplexNumber mult( ComplexNumber z)
  {
    float a = this.a * z.a - this.b * z.b;
    float b = this.a * z.b + this.b * z.a;
    
    this.a =a; this.b = b;
    
    return this;
  }
  public float length()
  {
    return (float)Math.sqrt(a*a + b*b);
  }
  
  public String toString()
  {
    return "[ComplexNumber] : " + a + " + " + b + "i";
  }
  
  public float   getReal()            {return a;}
  public float   getImaginary()       {return b;}
  public void    setReal(float v)     { a = v;  }
  public void    setImaginary(float v){ b = v;  }
  
//----------------------------------------Static Operations-----------------------------------------------------
  public static ComplexNumber add(ComplexNumber z1, ComplexNumber z2)
  {
    return new ComplexNumber(z1.getReal() + z2.getReal() ,z1.getImaginary() + z2.getImaginary()  );
  }
  public static ComplexNumber sub(ComplexNumber z1, ComplexNumber z2)
  {
    return new ComplexNumber(z1.getReal() - z2.getReal() ,z1.getImaginary() - z2.getImaginary()  );
  }
  public static ComplexNumber mult(ComplexNumber z1, ComplexNumber z2)
  {
    float a = z1.a * z2.a - z1.b * z2.b;
    float b = z1.a * z2.b + z1.b * z2.a;
    return new ComplexNumber(a ,b);
  }
  
  public static ComplexNumber add(ComplexNumber z1, float r)
  {
    return new ComplexNumber(z1.getReal() + r ,z1.getImaginary() );
  }
  public static ComplexNumber sub(ComplexNumber z1, float r)
  {
    return new ComplexNumber(z1.getReal() - r ,z1.getImaginary());
  }
  public static ComplexNumber mult(ComplexNumber z1, float r)
  {
    return new ComplexNumber(z1.a * r , z1.b * r);
  }
  
  public static ComplexNumber expi(float theta)
  {
    return new ComplexNumber((float)Math.cos(theta) , (float)Math.sin(theta));
  }
}
