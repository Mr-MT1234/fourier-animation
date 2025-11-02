
class SVGFunction implements ComplexFunction
{
  private ArrayList<SVGCommand> commands = new ArrayList<SVGCommand>();
  
  public SVGFunction(String path)
  {
    commands = extractPath(path);
  }
  
  public ComplexNumber evaluate(float t)
  {
    if(commands.size() == 0) return null;
    
    t = frac(t);
    float c = 1.0 / commands.size();
    int currentIndex = (int)(t/c);
    SVGCommand current = commands.get(currentIndex);
    PVector p =current.getPosition((t - c * currentIndex)/c);
    return new ComplexNumber(p.x,p.y);
  }
}

float frac(float t)
{
  return t - ((int)t);
}
