require "unicode_utils/downcase"

langs = {"sv" => "Swedish", "bg" => "Bulgarian", "hr" => "Croatian", "cs" => "Czech", "da" => "Danish", "nl" => "Dutch", "he" => "Hebrew", "hi" => "Hindi", "it" => "Italian", "lv" => "Latvian", "lt" => "Lithuanian", "el" => "Greek", "pl" => "Polish", "pt" => "Portuguese", "ro" => "Romanian", "ru" => "Russian", "sl" => "Slovenian", "sk" => "Slovak", "es" => "Spanish", "ca" => "Catalan", "fr" => "French", "de" => "German", "sq" => "Albanian", "uk" => "Ukrainian", "ar" => "Arabic"}
PATH = "C:\\Sasha\\D\\DGU\\UD26langs\\"

#slangs = ["sv", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "ar", "uk"]
#tlangs = ["sv", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "ar", "uk"]
slangs = ["ar", "he"]

#animacy_langs = ["ru", "uk", "cs", "pl", "sk", "hr", "sl", "hi"]
tlangs = ["ru", "uk", "cs", "pl", "sk"]

@ghash = {"0" => "Neut", "1" => "Fem", "2" => "Masc", "3" => "Com"}

def ave(array)
  sum = 0.0
  array.each do |el|
    sum += el
  end
  return sum/array.length
end

def hash_to_probs(hash)
  probs = Hash.new(0.0)
  sum = 0.0
  hash.values.uniq.each do |gender|
    probs[gender] = hash.values.count(gender)
    sum += hash.values.count(gender)
  end
  probs.each_key do |gender|
    probs[gender] = probs[gender]/sum
  end

  probs
end

def guess_gender(probs)
  randnumber = rand
  #STDERR.puts randnumber
  #if probs["Masc"] > 0
  tmasc = probs["Masc"] 
  tfem = tmasc + probs["Fem"]
  tneut = tfem + probs["Neut"]
  tcom = tneut + probs["Com"]
  if randnumber < tmasc
    guess = "2"
  elsif randnumber >= tmasc and randnumber < tfem
    guess = "1"
  elsif randnumber >= tfem and randnumber < tneut
    guess = "0"
  elsif randnumber >= tneut and randnumber < tcom
    guess = "3"
  end
  guess

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

out = File.open("inanimate.tsv","w:utf-8")

slangs.each do |slang|
  wordgenders = {}
 
  STDERR.puts "Processing langfile #{slang}"
  
  langfile = File.open("#{PATH}#{langs[slang]}.conllu","r:utf-8")
  langfile.each_line do |line|
    if line.strip != "" and line[0] != "#"
      line1 = line.strip.split("\t")
      form = UnicodeUtils.downcase(line1[1])
     
      if line1[3] == "NOUN" #or line1[3] == "PROPN"
        
        feats = feats_to_hash(line1[5])
        if wordgenders[form].nil? and ["Fem","Masc","Neut","Com"].include?(feats["Gender"])
          wordgenders[form] = feats["Gender"]
        end
       
      end    
    end
  end
  probs = hash_to_probs(wordgenders)
  #STDERR.puts "#{probs}"
  #for i in 1..10
  #  STDERR.puts guess_gender(probs)
  #end

#=begin
  tlangs.each do |tlang|
    STDERR.puts "#{slang}=>#{tlang}"
    anims = Hash.new(0)
    inans = Hash.new(0)
    STDERR.puts "Processing langfile #{tlang}"
    langfile = File.open("#{PATH}#{langs[tlang]}.conllu","r:utf-8")
    langfile.each_line do |line|
      if line.strip != "" and line[0] != "#"
        line1 = line.strip.split("\t")
        form = UnicodeUtils.downcase(line1[1])
        if line1[3] == "NOUN" #or line1[3] == "PROPN"
          feats = feats_to_hash(line1[5])
          if feats["Animacy"] == "Anim" or feats["Animacy"] == "Nhum" or feats["Animacy"] == "Hum"
            anims[form] += 1
          elsif feats["Animacy"] == "Inan"
            inans[form] += 1
          end
        end    
      end
    end

    correctgenders = {}
    preds = File.open("Voted\\#{slang}_#{tlang}_voted.tsv","r:utf-8")
    

    STDERR.puts "Reading predictions #{tlang}"
    rcorrect = 0.0
    preds.each_line.with_index do |line, ind|
      if ind > 0
        line1 = line.strip.split("\t")
        word = UnicodeUtils.downcase(line1[0])
        if inans[word] > anims[word]
          if line1[1] == line1[2]
            rcorrect += 1
          end        
          correctgenders[word] = line1[2]
        end
      end
    end    
    preds.close
    #total = correctgenders.keys.length
    
    STDERR.puts "Randomization"
    p = 0.0
    scorrect = 0.0
    for i in 1..10000 do 
      correct = 0.0
      
      correctgenders.each_pair do |word, gender|
        guess = guess_gender(probs)  
        if guess == gender
          correct += 1
        end         
      end
      scorrect += correct
      if correct >= rcorrect
        p += 1
      end
    end
    p = p/10000
    scorrect = scorrect/10000
    out.puts "#{slang}\t#{tlang}\t#{rcorrect}\t#{p}\t#{scorrect}"
  end
#=end
end