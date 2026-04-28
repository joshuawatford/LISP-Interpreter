
#takes a command like (+ 2 3) and splits up into a list like ["(", "+", "2", "3", ")"]
def separate(string)
    string2 = string.gsub(/[(]/, ' ( ') #adds spaces around opening parentheses
    string3 = string2.gsub(/[)]/, ' ) ') #adds spaces around closing parentheses
    list = string3.split #splits string into array of substrings
end

def isolate(list = [])
    stack = []
    list.each do |i|
        if i == '('
            stack.push([])
        elsif i == ')'
            newStack = stack.pop
            if stack.empty?
                return newStack
            end
            stack.last.push(newStack)
        else
            stack.last.push(i)
           
        
        end
    end
end

def identify(hash, string)
    if hash.key?(string)
        return hash[string].to_i
    else
        return string.to_i
    end
end

def evaluate(hash, array)

    if array[0] == "+"
        return identify(hash, array[1]) + identify(hash, array[2])
    elsif array[0] == "-"
        return identify(hash, array[1]) - identify(hash, array[2])
    elsif array[0] == "/"
        return identify(hash, array[1]) / identify(hash, array[2])
    elsif array[0] == "*"
        return identify(hash, array[1]) * identify(hash, array[2])
    elsif array[0] == "define"
        hash[array[1]] = identify(hash, array[2])
        return array[1]
    end
end

storage = {}
while true
    x = gets.chomp
    if x == "quit"
        break
    else
        x = separate(x)
        x = isolate(x)
        x = evaluate(storage, x)
        puts "#{x}"
    end
end


