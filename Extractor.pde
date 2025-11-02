ArrayList<SVGCommand> extractPath(String rawPath)
{
  ArrayList<SVGCommand> cmds = new ArrayList<SVGCommand>();
  PVector start = new PVector();
  PVector begining = start.copy();
  Translator current = null;
  
  for(char c : rawPath.toCharArray())
  {
    if(c == 'M')
    {
      if(current != null) cmds.addAll(current.end());
      current = new MoveTranslator(start,false);
    }
    if(c == 'm')
    {
      if(current != null) cmds.addAll(current.end());
      current = new MoveTranslator(start,true);
    }
    else if(c == 'C')
    {
      if(current != null) cmds.addAll(current.end());
      current = new CubicCurveTranslator(start,false);
    }
    else if(c == 'c')
    {
      if(current != null) cmds.addAll(current.end());
      current = new CubicCurveTranslator(start,true);
    }
    else if(c == 'Q')
    {
      if(current != null) cmds.addAll(current.end());
      current = new QuadraticCurveTranslator(start,false);
    }
    else if(c == 'q')
    {
      if(current != null) cmds.addAll(current.end());
      current = new QuadraticCurveTranslator(start,true);
    }
    else if(c == 'L')
    {
      if(current != null) cmds.addAll(current.end());
      current = new LineTranslator(start,false);
    }
    else if(c == 'l')
    {
      if(current != null) cmds.addAll(current.end());
      current = new LineTranslator(start,true);
    }
    else if(c == 'L')
    {
      if(current != null) cmds.addAll(current.end());
      current = new LineTranslator(start,false);
    }
    else if(c == 'l')
    {
      if(current != null) cmds.addAll(current.end());
      current = new LineTranslator(start,true);
    }
    else if(c == 'L')
    {
      if(current != null) cmds.addAll(current.end());
      current = new LineTranslator(start,false);
    }
    else if(c == 'l')
    {
      if(current != null) cmds.addAll(current.end());
      current = new LineTranslator(start,true);
    }
    else if(c == 'Z' || c == 'z')
    {
      if(current != null) cmds.addAll(current.end());
      cmds.add(new LineCommand(start , begining));
    }
    else
    {
      if(current != null) current.process(c);
    }
  }
  if(current != null) cmds.addAll(current.end());
  return cmds;
}


class PramDispatcher
{
  private String memory = "";
  int l = 0;
  
  public float process(char c)
  {
    if(c == ' ' || c == ',')
    {
      if(l > 0)
      {
        float value = Float.valueOf(memory);
        memory = "";
        l = 0;
        return value;
      }
    }
    else if(c == '-')
    {
      if(l > 0)
      {
        float value = Float.valueOf(memory);
        memory = "-";
        l = 0;
        return value;
      }
      else
      {
        memory += c;
        l++;
      }
    }
    else if(isNumber(c))
    {
      memory += c;
      l++;
    }
    
    return Float.NaN;
  }
  
  public float getCurrentValue()
  {
    return Float.valueOf(memory);
  }
  
  private boolean isNumber(char c)
  {
    return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9' || c == '.';
  }
}

interface Translator
{
  public void process(char c);
  public ArrayList<SVGCommand> end();
}

class MoveTranslator implements Translator
{
  private PramDispatcher pd = new PramDispatcher();
  private float[] inputs = new float[2];
  private int i  = 0;
  
  private PVector start;
  private PVector relativeTo;
  
  public MoveTranslator(PVector s,boolean r)
  {
    relativeTo = r ? s : new PVector();
    start = s;
  }
  
  public void process(char c)
  {
    Float f = pd.process(c);
     if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
  }
  public ArrayList<SVGCommand> end()
  {
    return new ArrayList<SVGCommand>();
  }
  
  private void addInput(float f)
  {
    inputs[i++] = f;
    
    if(i > inputs.length - 1)
     { 
       start.set(inputs[0] + relativeTo.x ,inputs[1] + relativeTo.y);
       relativeTo = start.copy();
       i = 0;
     }
  }
}


class CubicCurveTranslator implements Translator
{
  private PramDispatcher pd = new PramDispatcher();
  private ArrayList<SVGCommand> commands = new ArrayList<SVGCommand>();
  private float[] inputs = new float[6];
  private int i = 0;
  private PVector start;
  private PVector relativeTo;
  private PVector lastControlPoint = new PVector();
  
  public CubicCurveTranslator(PVector s,boolean r)
  {
    relativeTo = r ? s : new PVector();
    start = s;
  }
  
   void process(char c)
   {
     if(c == 'S')
     {
       addInput(2 * start.x - (lastControlPoint.x));
       addInput(2 * start.y - (lastControlPoint.y));
       return;
     }
     else if(c == 's')
     {
       addInput(2 * start.x - (lastControlPoint.x - relativeTo.x));
       addInput(2 * start.y - (lastControlPoint.y - relativeTo.y));
       return;
     }
     
     Float f = pd.process(c);
     if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
   }
   
  private void addInput(float f)
  {
    inputs[i++] = f;
    
    if(i > inputs.length - 1)
     { 
       SVGCommand cmd = new CubicCurve(start,new PVector(inputs[4] + relativeTo.x,inputs[5] + relativeTo.y),
                                             new PVector(inputs[0] + relativeTo.x,inputs[1] + relativeTo.y) ,
                                             new PVector(inputs[2] + relativeTo.x,inputs[3] + relativeTo.y));
       commands.add(cmd);
       start.set(inputs[4] + relativeTo.x ,inputs[5] + relativeTo.y);
       lastControlPoint = new PVector(inputs[2] + relativeTo.x ,inputs[3] + relativeTo.y);
       relativeTo = start.copy();
       i = 0;
     }
  }
   
  public ArrayList<SVGCommand> end()
  {
    Float f = pd.getCurrentValue();
    if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
    return commands; //<>//
  }
}


class QuadraticCurveTranslator implements Translator
{
  
  private PramDispatcher pd = new PramDispatcher();
  private ArrayList<SVGCommand> commands = new ArrayList<SVGCommand>();
  private float[] inputs = new float[4];
  private int i = 0;
  private PVector start;
  private PVector relativeTo;
  private PVector lastControlPoint = new PVector();
  
  public QuadraticCurveTranslator(PVector s,boolean r)
  {
    relativeTo = r ? s : new PVector();
    start = s;
  }
  
   void process(char c)
   {
     if(c == 'T')
     {
       addInput(2 * start.x - (lastControlPoint.x));
       addInput(2 * start.y - (lastControlPoint.y));
       return;
     }
     else if(c == 't')
     {
       addInput(2 * start.x - (lastControlPoint.x - relativeTo.x));
       addInput(2 * start.y - (lastControlPoint.y - relativeTo.y));
       return;
     }
     
     Float f = pd.process(c);
     if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
   }
   
  private void addInput(float f)
  {
    inputs[i++] = f;
    
    if(i > inputs.length - 1)
     { 
       SVGCommand cmd = new QuadraticCurve(start,new PVector(inputs[2] + relativeTo.x,inputs[3] + relativeTo.y),
                                                 new PVector(inputs[0] + relativeTo.x,inputs[1] + relativeTo.y));
       commands.add(cmd);
       start.set(inputs[4] + relativeTo.x ,inputs[5] + relativeTo.y);
       lastControlPoint = new PVector(inputs[0] + relativeTo.x ,inputs[1] + relativeTo.y);
       relativeTo = start.copy();
       i = 0;
     }
  }
   
  public ArrayList<SVGCommand> end()
  {
    Float f = pd.getCurrentValue();
    if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
    return commands;
  }
}

class LineTranslator implements Translator
{
  private PramDispatcher pd = new PramDispatcher();
  private ArrayList<SVGCommand> commands = new ArrayList<SVGCommand>();
  private float[] inputs = new float[2];
  private int i = 0;
  private PVector start;
  private PVector relativeTo;
  
  public LineTranslator(PVector s,boolean r)
  {
    relativeTo = r ? s : new PVector();
    start = s;
  }
  
   void process(char c)
   { 
     Float f = pd.process(c);
     if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
   }
   
  private void addInput(float f)
  {
    inputs[i++] = f;
    
    if(i > inputs.length - 1)
     { 
       SVGCommand cmd = new LineCommand(start,new PVector(inputs[0] + relativeTo.x,inputs[1] + relativeTo.y));
       commands.add(cmd);
       start.set(inputs[0] + relativeTo.x ,inputs[1] + relativeTo.y);
       relativeTo = start.copy();
       i = 0;
     }
  }
   
  public ArrayList<SVGCommand> end()
  {
    Float f = pd.getCurrentValue();
    if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
    return commands;
  }
}

class HorizontalTranslator implements Translator
{
  private PramDispatcher pd = new PramDispatcher();
  private ArrayList<SVGCommand> commands = new ArrayList<SVGCommand>();
  private float[] inputs = new float[1];
  private int i = 0;
  private PVector start;
  private PVector relativeTo;
  
  public HorizontalTranslator(PVector s,boolean r)
  {
    relativeTo = r ? s : new PVector();
    start = s;
  }
  
   void process(char c)
   { 
     Float f = pd.process(c);
     if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
   }
   
  private void addInput(float f)
  {
    inputs[i++] = f;
    
    if(i > inputs.length - 1)
     { 
       SVGCommand cmd = new LineCommand(start,new PVector(inputs[0] + relativeTo.x, start.y));
       commands.add(cmd);
       start.set(inputs[0] + relativeTo.x, start.y);
       relativeTo = start.copy();
       i = 0;
     }
  }
   
  public ArrayList<SVGCommand> end()
  {
    Float f = pd.getCurrentValue();
    if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
    return commands;
  }
}

class VerticalTranslator implements Translator
{
  private PramDispatcher pd = new PramDispatcher();
  private ArrayList<SVGCommand> commands = new ArrayList<SVGCommand>();
  private float[] inputs = new float[1];
  private int i = 0;
  private PVector start;
  private PVector relativeTo;
  
  public VerticalTranslator(PVector s,boolean r)
  {
    relativeTo = r ? s : new PVector();
    start = s;
  }
  
   void process(char c)
   { 
     Float f = pd.process(c);
     if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
   }
   
  private void addInput(float f)
  {
    inputs[i++] = f;
    
    if(i > inputs.length - 1)
     { 
       SVGCommand cmd = new LineCommand(start,new PVector(start.x,inputs[0] + relativeTo.y));
       commands.add(cmd);
       start.set(start.x,inputs[0] + relativeTo.y);
       relativeTo = start.copy();
       i = 0;
     }
  }
   
  public ArrayList<SVGCommand> end()
  {
    Float f = pd.getCurrentValue();
    if(!f.equals(Float.NaN))
     {
       addInput(f);
     }
    return commands;
  }
}
