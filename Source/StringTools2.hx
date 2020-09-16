package;

/**
 * ...
 * @author Matthias Faust
 */
class StringTools2 {
	public static function left(str:String, len:Int):String {
		return str.substr(0, len);
	}
	
	public static function removeAt(str:String, pos:Int, length:Int):String {
       if (str.isEmpty() || length < 1)
           return str;

       final strLen = str.length;
       pos = pos < 0 ? strLen + pos : pos;

       if (pos < 0)
           throw "[pos] must be smaller than -1 * str.length";

       if (pos + length >= strLen)
           return str.substring(0, pos);

       return str.substring(0, pos) + str.substring(pos + length);
   }
   
   public static function compact(str:String):String {
	  while (str.indexOf("  ") > -1) {
		str = str.replaceAll("  ", " ");
	  }
	  
      return StringTools.trim(str);
   }
   
   inline
   public static function removeAll(searchIn:String, searchFor:String):String
      return StringTools.replace(searchIn, searchFor, "");
	  
	public static function replaceAll(searchIn:String, searchFor:String, replaceWith:String):String {
      return StringTools.replace(searchIn, searchFor, replaceWith);
   }
   
   public static function insertAt(str:String, pos:Int, insertion:String):String {
      if (str == null)
         return null;

      final strLen = str.length;
      pos = pos < 0 ? strLen + pos : pos;

      if (pos < 0 || pos > strLen)
         throw "Absolute value of [pos] must be <= str.length";

      if (insertion.isEmpty())
         return str;

      return str.substring(0, pos) + insertion + str.substring(pos);
   }
   
   inline
   public static function endsWithIgnoreCase(searchIn:String, searchFor:String):Bool {
      if (searchIn == null || searchFor == null)
         return false;

      return  StringTools.endsWith(searchIn.toLowerCase(), searchFor.toLowerCase());
   }
   
   inline
   public static function isEmpty(str:String):Bool
      return str == null || str.length == 0;
}