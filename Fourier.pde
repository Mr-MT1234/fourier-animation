interface ComplexFunction
{
  public ComplexNumber evaluate(float t);
}

public static ComplexNumber integral(ComplexFunction f, float a , float b)
{
  if(a > b) return integral(f, b, a).mult(new ComplexNumber(-1 , 0));
  
  int resolution = 1000;
  
  float step = (b - a) / resolution;
  
  ComplexNumber sum = new ComplexNumber();
  
  for(float t = a; t < b ; t += step)
  {
    sum.add(f.evaluate(t));
  }
  
  return ComplexNumber.mult(sum , step);
}


class FourierElement implements ComplexFunction
{
  private int frequency;
  private ComplexNumber initialState;
  
  public FourierElement(int f, ComplexNumber c)
  {
    frequency = f;
    initialState = c;
  }
  
  public ComplexNumber evaluate(float t)
  {
    return ComplexNumber.mult(initialState , ComplexNumber.expi(2 * PI * frequency * t));
  }
  
  public void show(float t,ComplexNumber center)
  {
    noFill();
    stroke(255,255,255,50);
    strokeWeight(1 / scale * 1);
    
    circle(center.getReal(),center.getImaginary() , initialState.length() * 2);
    
    ComplexNumber newCenter = ComplexNumber.add(evaluate(t) , center);
    
    stroke(50,100,220 , 150);
    strokeWeight(1 / scale * 5);
    line(center.getReal(),center.getImaginary(),newCenter.getReal(),newCenter.getImaginary());
    
    center.setReal(newCenter.getReal());
    center.setImaginary(newCenter.getImaginary());
    
    stroke(255,255,255);
    strokeWeight(1 / scale * 5);
    point(center.getReal(),center.getImaginary());
  }
}

class Holder implements ComplexFunction
{
  private int frequency;
  private ComplexFunction function;
  
  public Holder(int f, ComplexFunction c)
  {
    frequency = f;
    function = c;
  }
  
  public ComplexNumber evaluate(float t)
  {
    return ComplexNumber.mult(function.evaluate(t) , ComplexNumber.expi(-2 * PI * frequency * t));
  }
}

class FourierSerie implements ComplexFunction
{
  private ArrayList<FourierElement> elements = new ArrayList<FourierElement>();
  
  public FourierSerie(ComplexFunction f)
  {
    for(int i = -Accuracy/2 ; i < Accuracy/2 ; i++)
    {
      ComplexNumber c = integral(new Holder(i , f) , 0 , 1);
      FourierElement e = new FourierElement(i , c);
      elements.add(e);
    }
  }
  
  public ComplexNumber evaluate(float t)
  {
    ComplexNumber r = new ComplexNumber();
    
    for(FourierElement e : elements)
    {
      r.add(e.evaluate(t));
    }
    
    return r;
  }
  
  public ComplexNumber show(float t)
  {
    ComplexNumber center = new ComplexNumber();
    int midIndex = Accuracy / 2 ;
    elements.get(midIndex).show(t , center);
    
    for(int i = 1 ; i < Accuracy / 2;i++)
    {
      elements.get(midIndex + i).show(t , center);
      elements.get(midIndex - i).show(t , center);
    }
    
    return center;
  }
}
