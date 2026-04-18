
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


x = gets
puts "#{x}"
puts "calling separate"
x = separate(x)
puts "#{x}"
puts "calling isolate"
x = isolate(x)
puts "#{x}"

