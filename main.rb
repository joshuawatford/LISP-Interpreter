
#takes a command like (+ 2 3) and splits up into a list like ["(", "+", "2", "3", ")"]
def separate(string)
    string2 = string.gsub(/[(]/, ' ( ') #adds spaces around opening parentheses
    string3 = string2.gsub(/[)]/, ' ) ') #adds spaces around closing parentheses
    list = string3.split #splits string into array of substrings
end

#takes an array of separated characters and places them into a stack. creates a new stack 
#any time an opening parenthesis is detected, and pushes that stack as an enclosed object 
#any time a closing parenthesis is detected.
def isolate(list = [])
    stack = [] #main stack
    if !list.any? { |i| i == '('} #if no opening parentheses exist in the list i.e. if the user tries to write "+ 2 3)" etc.
        puts "opening parenthesis not found"
        return nil
    end
    list.each do |i| #iterating through list
        if i == '('
            stack.push([]) #push a new list onto the stack
        elsif i == ')' 
            newStack = stack.pop #pop the most recently added list out of the main stack and assign it to a temporary stack
            if stack.empty? #if the main stack is empty, then all expressions were properly isolated
                return newStack #return result
            end
            stack.last.push(newStack) #add the temporary stack back to the main stack, but to the most recent stack in the list (nesting)
        else
            stack.last.push(i) #add element to main stack
           
        
        end
    end
    if !stack.empty? #if main stack isnt empty, then the expression was missing a closing parenthesis typical of lisp expressions
        puts "unclosed parenthesis found"
        return nil
    end
end

#verifies whether a passed element is a number to be operated with or a function to be defined. 
#works recursively with evaluate to solve nested expressions
def identify(hash, string)

    if string.is_a?(Array) #if the element is an array itself
        return evaluate(hash, string) #call evaluate to simplify the expression and return the result as an int (useful for expressions like (+ 2 (+ 1 2)))
    elsif hash.key?(string) #if the element is already a key in the hash
        return hash[string].to_i #return the value for said key as an int
    else
        return string.to_i #return the value as an int
    end
end


#takes fully parsed and refined list of operators, functions calls, numbers, etc. and solves them as necessary based on what is called. 
def evaluate(hash, array)

    if array[0] == "+" 
        return identify(hash, array[1]) + identify(hash, array[2]) #addition
    elsif array[0] == "-"
        return identify(hash, array[1]) - identify(hash, array[2]) #subtraction
    elsif array[0] == "/"
        if identify(hash, array[2]) == 0 #checks to prevent division by 0
            puts "arithmetic error DIVISION-BY-ZERO signaled \n Operation was (/ #{array[1]} #{array[2]})"
            return nil
        else
            return identify(hash, array[1]) / identify(hash, array[2]) #division
        end
    elsif array[0] == "*" 
        return identify(hash, array[1]) * identify(hash, array[2]) #multiplication
    elsif array[0] == "define" #function definition
        if array[1].is_a?(Array) #if the first element (beyond 'define', that is) is an array, then it will be a function definition with multiple elements and thus an array)
            #uses the user provided function name as a key, and assigns the provided variable
            #name as a value along with the expression that represents that function (function 'square' being represented by (* x x), etc.)
            hash[array[1][0]] = [array[1][1..], array[2]] 
            return array[1][0] #confirm successful definition of function
        else
            hash[array[1]] = identify(hash, array[2]) #otherwise assign the user provided number to the user provided variable key
            return array[1] #confirmation of definition
        end
    else #if not an operator or define, then it will be a custom function 
        temp_storage = hash.dup #create a temporary copy of the storage hash
        
        if hash.key?(array[0]) #if the function call exists in the hash as a key, it has been successfully defined and is usable
            value = hash[array[0]][0] #assigns the value of the key to a variable (when defining 'square n' -> n is the value (a parameter) for key 'square'). this can be one parameter or a list of them if needed
            expr = hash[array[0]][1] #the expression that will be used when operating with the function 

            value.each_with_index do |valuex, i| #iterates through the function's parameters
                temp_storage[valuex] = identify(hash, array[1..][i]) #identifies each argument from the function call as either a variable or an expression and assigns the output as a value to the parameter as a key
            end

            evaluate(temp_storage, expr) #recursive call to evaluate the provided expression until it reaches its base case and is solved
        else #the function call is not a key and wasnt assigned
            puts "function #{array[0]} not defined" #error message
            return nil
        end
    end
end


storage = {}
#repl loop for the entire program, what keeps the lisp program feeling immersive
while true
    x = gets.chomp #user input for operations
    if x == "quit" #user can type quit anytime to end the program naturally
        break
    elsif x == "" #user can press enter without typing anything and the loop will keep running without error
        next
    else #if user provides an expression or operation
        x = separate(x) #call separate on x and overwrite x with the output
        x = isolate(x) #call isolate on x and then overwrite it again
        if x == nil #if isolate happens to come across any issues (like missing parentheses)
            next #proceed without error (errors will be printed as they are found and handled within the method itself)
        end
        x = evaluate(storage, x) #call evaluate, passing the main storage for defining variables so that operations can be performed efficiently
        puts "#{x}" #output final result
    end
end


