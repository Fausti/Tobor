package;

/**
 * ...
 * @author Matthias Faust
 */
class Utils {
	public static function fixedFloat(v:Float, ?precision:Int = 2):Float {
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
	
	public static function distance(x0:Float, y0:Float, x1:Float, y1:Float):Float {
		return Math.sqrt((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1));
	}
	
	// Randomkram...
	
	private static var internalSeed:Float = 1;
	
	private static inline var MAX_VALUE_INT:Int = 0x7FFFFFFF;
	private static inline var MULTIPLIER:Float = 48271.0;
	private static inline var MODULUS:Int = MAX_VALUE_INT;
	
	private static inline function generate():Float {
		return internalSeed = (internalSeed * MULTIPLIER) % MODULUS;
	}
	
	public static function random(Min:Float = 0, Max:Float = 1, ?Excludes:Array<Float>):Float
	{
		var result:Float = 0;
		
		if (Min == 0 && Max == 1 && Excludes == null)
		{
			return generate() / MODULUS;
		}
		else if (Min == Max)
		{
			result = Min;
		}
		else
		{
			// Swap values if reversed.
			if (Min > Max)
			{
				Min = Min + Max;
				Max = Min - Max;
				Min = Min - Max;
			}
			
			if (Excludes == null)
			{
				result = Min + (generate() / MODULUS) * (Max - Min);
			}
			else
			{
				do
				{
					result = Min + (generate() / MODULUS) * (Max - Min);
				}
				while (Excludes.indexOf(result) >= 0);
			}
		}
		
		return result;
	}
	
	public static inline function chance(Chance:Float = 50):Bool {
		return random(0, 100) < Chance;
	}
	
	// Step Iterator
	
	public static function range(start:Int, end:Int, step:Int):StepIterator {
		return new StepIterator(start, end, step);
	}
}

class StepIterator {
	var end:Int;
	var step:Int;
	var index:Int;

	public inline function new(start:Int, end:Int, step:Int) {
		this.index = start;
		this.end = end;
		this.step = step;
	}

	public inline function hasNext() {
        if (this.step > 0) 
        	return index < end;
        else return index > end;
    }
	
	public inline function next() return (index += step) - step;
}