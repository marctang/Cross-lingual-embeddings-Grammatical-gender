langs = {"ar" => "Arabic", "sv" => "Swedish", "bg" => "Bulgarian", "hr" => "Croatian", "cs" => "Czech", "da" => "Danish", "nl" => "Dutch", "he" => "Hebrew", "hi" => "Hindi", "it" => "Italian", "lv" => "Latvian", "lt" => "Lithuanian", "el" => "Greek", "pl" => "Polish", "pt" => "Portuguese", "ro" => "Romanian", "ru" => "Russian", "sl" => "Slovenian", "sk" => "Slovak", "es" => "Spanish", "ca" => "Catalan", "fr" => "French", "de" => "German", "sq" => "Albanian", "uk" => "Ukrainian"}

slangs = ["sv", "ar", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "uk"]

tlangs = ["ar", "sv", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "uk"]


kappas = {}
runs = [1, 6, 11, 16, 18, 19, 20, 21, 22, 23]
nruns = runs.length

kappa = false
voting = true

doublets = {}
#datasizes = File.open("datasizes.tsv","w:utf-8")
datapoints = {}


tlangs.each do |tlang|
  slangs.each do |slang|
    correct = {}
    if kappa 
      words = Hash.new{|hash, key| hash[key] = Array.new}
    elsif voting
      words = Hash.new{|hash, key| hash[key] = Hash.new(0.0)}    
    end 
   
    for i in runs do 
      STDERR.puts "#{slang}=>#{tlang} #{i}"
      preds = File.open("Predictions\\final_run#{i}_fold2_#{slang}_#{tlang}.txt","r:utf-8")
      preds.each_line.with_index do |line, index|
        if index > 0 
          line1 = line.split(", ")
          #if ["ar", "he"].include?(tlang)
          #  word_index = 3
          #  label_index = 2
          #  prediction_index = 1
          #  conf_index = 0
          #else
            word_index = 0
            label_index = 2
            prediction_index = 1
            conf_index = 3
          #end
        correct[line1[word_index]] = line1[label_index]
        if kappa 
          if words[line1[word_index]].length.to_i < runs.length
            words[line1[word_index]] << line1[prediction_index].to_i
          else
            doublets[line1[prediction_index]] = tlang
          end
        elsif voting
          words[line1[word_index]][line1[prediction_index]] += line1[conf_index].to_f
        end
      
        end
      end
      
    end
#=begin    
    #m = 0
    #STDOUT.puts words
    if kappa
      o = File.open("kappas\\#{slang}_#{tlang}_for_kappa.tsv","w:utf-8")
    elsif voting
      o = File.open("voted\\#{slang}_#{tlang}_voted.tsv","w:utf-8")
      o.puts "word\tprediction\tlabel"
    end
    words.each_pair do |word, votes|
      #STDERR.puts word
      if kappa 
        o.puts votes.join("\t")
      elsif voting
        voted = votes.key(votes.values.max)
        if votes.values.count(votes.values.max) > 1
          STDERR.puts word
          STDERR.puts "#{votes}"
        end
        o.puts "#{word}\t#{voted}\t#{correct[word]}"
      end
      
      
    end
    o.close
    datapoints[tlang] = words.keys.length
#=end
  end
  #datasizes.puts "#{tlang}\t#{datapoints[tlang]}"
end


#doublets.each_pair do |k, v|
#  STDOUT.puts "#{k}\t#{v}"
#end