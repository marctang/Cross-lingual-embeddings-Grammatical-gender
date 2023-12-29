langs = {"sv" => "Swedish", "bg" => "Bulgarian", "hr" => "Croatian", "cs" => "Czech", "da" => "Danish", "nl" => "Dutch", "he" => "Hebrew", "hi" => "Hindi", "it" => "Italian", "lv" => "Latvian", "lt" => "Lithuanian", "el" => "Greek", "pl" => "Polish", "pt" => "Portuguese", "ro" => "Romanian", "ru" => "Russian", "sl" => "Slovenian", "sk" => "Slovak", "es" => "Spanish", "ca" => "Catalan", "fr" => "French", "de" => "German", "sq" => "Albanian", "uk" => "Ukrainian", "ar" => "Arabic"}
slangs = ["sv", "bg", "hr", "cs", "da", "nl", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "uk"]
#slangs = ["ar", "he"]

#tlangs = ["sv", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "ar", "uk"]
animacy_langs = ["ru", "uk", "cs", "pl", "sk", "hr", "sl", "hi"]

outfile = File.open("fullregr.tsv","w:utf-8")
outfile.puts "word\tprediction\tlabel\tfreq\tanimacy\tbaseform\tcorrect\tdistance\tsourcelang\ttarget"


distances = {}
phylo = File.open("Phylodist.csv","r:utf-8")
phylo.each_line.with_index do |line, index|
  if index > 0
    line1 = line.strip.split(",")
    distances["#{line1[0]}_#{line1[1]}"] = line1[2].to_f
  end
end

animacy_langs.each do |tlang|
  slangs.each do |slang|
    STDERR.puts "#{slang}=>#{tlang}"
    regr = File.open("Regression\\#{slang}_#{tlang}.tsv","r:utf-8")
    regr.each_line.with_index do |line, index|
      if index > 0
        distance = distances["#{slang}_#{tlang}"]
        outfile.puts "#{line.strip}\t#{distance}\t#{slang}\t#{tlang}"
      end
    end
  end  
end