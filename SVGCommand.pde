
interface SVGCommand
{
  PVector getPosition(float t);
}

class LineCommand implements SVGCommand
{
  private PVector start , end; 
  
  public LineCommand(PVector s , PVector e)
  {
    start = s;
    end = e;
  }
  
  PVector getPosition(float t)
   {
     return PVector.add(PVector.mult(start,1 - t) , PVector.mult(end,t));
   }
}

class CubicCurve implements SVGCommand
{
  private PVector p0 , p1,p2,p3; 
  
  public CubicCurve(PVector s , PVector e ,PVector c1 , PVector c2)
  {
    p0 = s.copy();
    p1 = c1.copy();
    p2 = c2.copy();
    p3 = e.copy();
  }
  
  PVector getPosition(float t)
   {
     PVector pr1 = PVector.mult(p0 , pow(1 - t , 3));
     PVector pr2 = PVector.mult(p1 , 3 * pow(1 - t , 2) * t);
     PVector pr3 = PVector.mult(p2 , 3 * (1 - t) * t * t);
     PVector pr4 = PVector.mult(p3 , t * t * t);

     return PVector.add(PVector.add(pr1, pr2) , PVector.add(pr3 , pr4));
   }
}

class QuadraticCurve implements SVGCommand
{
  private PVector p0 , p1,p2; 
  
  public QuadraticCurve(PVector s , PVector e ,PVector c)
  {
    p0 = s;
    p1 = c;
    p2 = e;
  }
  
  PVector getPosition(float t)
   {
     PVector pr1 = PVector.mult(p0 , pow(1 - t , 2));
     PVector pr2 = PVector.mult(p1 , 2 * (1 - t) * t);
     PVector pr3 = PVector.mult(p2 , t * t);

     return PVector.add(PVector.add(pr1, pr2) , pr3);
   }
}
