#require "rinruby"
require "unicode_utils/downcase"

PATH = "C:\\Sasha\\D\\DGU\\UD26langs\\"

langs = {"sv" => "Swedish", "bg" => "Bulgarian", "hr" => "Croatian", "cs" => "Czech", "da" => "Danish", "nl" => "Dutch", "he" => "Hebrew", "hi" => "Hindi", "it" => "Italian", "lv" => "Latvian", "lt" => "Lithuanian", "el" => "Greek", "pl" => "Polish", "pt" => "Portuguese", "ro" => "Romanian", "ru" => "Russian", "sl" => "Slovenian", "sk" => "Slovak", "es" => "Spanish", "ca" => "Catalan", "fr" => "French", "de" => "German", "sq" => "Albanian", "uk" => "Ukrainian", "ar" => "Arabic"}

slangs = ["sv", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "ar", "uk"]
#tlangs = ["ru", "cs", "uk", "sl", "sk", "hi"]
#tlangs = ["ru", "uk"]

tlangs = ["sv", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "ar", "uk"]

animacy_langs = ["ru", "uk", "cs", "pl", "sk", "hr", "sl", "hi"]

def ave(array)
  sum = 0.0
  array.each do |el|
    sum += el
  end
  return sum/array.length
end

def feats_to_hash(feats)
  fhash = Hash.new("")
  if feats != "_"
    feats2 = feats.split("|")
    feats2.each do |feat2|
      fhash[feat2.split("=")[0]] = feat2.split("=")[1]
    end
  end
  fhash
end

##STDOUT.puts "source_id\tsource_language\ttarget_id\ttarget_language\tave_freq_correct\tave_freq_wrong\tp_value"
#STDOUT.puts "source_id\tsource_language\ttarget_id\ttarget_language\tprop_anim_correct\tprop_inan_correct\tp_value"

tlangs.each do |tlang|
  if animacy_langs.include?(tlang)
    wordfreqs = Hash.new(0)
   #wordfeats = {} #taking only the first one!
    STDERR.puts "Processing langfile..."
    anims = Hash.new(0)
    inans = Hash.new(0)
    sings = Hash.new(0)
    plurs = Hash.new(0)
    base = Hash.new(0)
    nbase = Hash.new(0)
    langfile = File.open("#{PATH}#{langs[tlang]}.conllu","r:utf-8")
    langfile.each_line do |line|
      if line.strip != "" and line[0] != "#"
        line1 = line.strip.split("\t")
        form = UnicodeUtils.downcase(line1[1])
       
        if line1[3] == "NOUN" #or line1[3] == "PROPN"
          wordfreqs[form] += 1
           #wordfeats[line1[1]] = line1[5]
        
          feats = feats_to_hash(line1[5])
          #index = 1
               
          if feats["Animacy"] == "Anim" or feats["Animacy"] == "Nhum" or feats["Animacy"] == "Hum"
            anims[form] += 1
          elsif feats["Animacy"] == "Inan"
            inans[form] += 1
          end
		  
          if line1[2] != "_"
            if form == UnicodeUtils.downcase(line1[2])
              base[form] += 1 
            else
              nbase[form] += 1 
            end
          end
                
        end    #end
      end
    end
    #STDOUT.puts "#{anims}"
    slangs.each do |slang|
      #STDOUT.puts "#{anims}"
      STDERR.puts "#{slang}=>#{tlang}"
      preds = File.open("Voted\\#{slang}_#{tlang}_voted.tsv","r:utf-8")
      outfile = File.open("Regression\\#{slang}_#{tlang}.tsv","w:utf-8")
      outfile.puts "word\tprediction\tlabel\tfreq\tanimacy\tbaseform\tcorrect"
    
      
      #predhash = {}
      #outfile.puts "word\tprediction\tgold\tconfidence\tfreq\tfeats\tcorrect"
      ##corr_freqs = []
      ##wrong_freqs = []
      #anim_correct = 0.0
      #anim_total = 0.0
      #inanim_correct = 0.0
      #inanim_total = 0.0
      
      STDERR.puts "Processing predictions..."
      preds.each_line.with_index do |line, ind|
        if ind > 0
          line1 = line.strip.split("\t")
          word = UnicodeUtils.downcase(line1[0])
          #STDOUT.puts word
          #STDOUT.puts "#{anims[word]}"
          if (anims[word] > 0 or inans[word] > 0) and (base[word] > 0 or nbase[word] > 0)# and (anims[word] > 0 or inans[word] > 0)

            if anims[word] >= inans[word]
              animacy = "anim"
            else
              animacy = "inan"
            end
          #if sings[word] >= plurs[word]

            if base[word] >= nbase[word]
              baseform = "baseform"
            else
              baseform = "nonbase"
            end

          #  number = "sing"
          #else
          #  number = "plur"
          #end
          
            if line1[1] == line1[2]
              correct = 1
            else 
              correct = 0
            end
        
            outfile.puts "#{line1.join("\t")}\t#{wordfreqs[word]}\t#{animacy}\t#{baseform}\t#{correct}"
          end
        end
      end
    end
  end
end