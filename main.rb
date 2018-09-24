require 'json'
exerciseJson = File.read('exercises.json')
@exercisesHash = JSON.parse(exerciseJson)

@response = ""
@selectedExercise = ""


#FIXME Allow for multiple users

#start up screen
def startScreen
loop do
    puts "Welcome to Lifts Tracker"
    puts ""
    puts "Please enter your name"
    puts ""
    #Only works with 'blake' at the moment
    @response = gets.downcase.chomp
        if @response == "blake"
        showStats
        else 
            system"clear"
            puts "invalid answer"
            sleep(2)
        end
    end
end

#Asks what muscle group was trained
def showStats
    loop do
    system"clear"
    puts "Hi #{@response.capitalize}"
    puts "What did you train today?"
    puts ""
    puts "Options: Chest, Back, Legs, Biceps, Triceps, Shoulders (type 'exit' to leave)"
    muscleGroup = gets.downcase.chomp
        if muscleGroup == "exit"
            puts "Ok bye"
            sleep(2)
            system"clear"
            exit
        elsif muscleGroup = @exercisesHash[muscleGroup]
        listExercises(muscleGroup)
        else
            puts "Invalid selection"
            sleep(2)
        end
    end
end

def listExercises(muscleGroup)
    loop do
        system"clear"
        puts "Enter an exercise from the following list ('back' to go back or 'exit' to leave):"
        puts ""
        muscleGroup.each do |x|
                puts x["name"]
        end
        puts ""
        exercise = gets.downcase.chomp
        if exercise == "exit"
            puts "Okay bye"
            sleep(3)
            exit
        elsif exercise == "back"
            break
        elsif exercise = muscleGroup.find {|x| x["name"].downcase == exercise}
            @selectedExercise = exercise
            displayExercise
            break
        else system"clear"
            puts "invalid answer"
            sleep(2)
        end
    end
end


def displayExercise
    system"clear"
    if @selectedExercise["weight"] == 0
        puts "You haven't yet entered your lift details for this exercise."
        updateLift
    elsif @selectedExercise["weight"] > 0
        loop do
        puts "What would you like to do for #{@selectedExercise["name"]}?"
        puts ""
        puts "1. Check last lift, 2. Update lift details, 3. Go back, 4. Exit"
        print "Please enter a number: "
        whatDo = gets.chomp.to_i
            if whatDo == 1
                puts "Your last lift for #{@selectedExercise["name"]} was #{@selectedExercise["reps"]} reps at #{@selectedExercise["weight"]} kg and you believe you #{@selectedExercise["canAdvance"]} lift heavier next time"
                sleep(5)
                system"clear"
            elsif whatDo == 2
                updateLift
            elsif whatDo == 3
                break
            elsif whatDo == 4
                system"clear"
                puts "Okay bye"
                sleep(3)
                system"clear"
            else puts "Not a valid answer"
            end
        end
    end
end


#FIXME - make sure user can only input numbers for weight & reps
def updateLift
        puts "Please enter your max weighted lift in kg's for #{@selectedExercise["name"]}"
        @selectedExercise["weight"] = gets.downcase.chomp.to_f
        system"clear"
        puts "How many reps at #{@selectedExercise["weight"]}kg's?"
        @selectedExercise["reps"] = gets.downcase.chomp.to_i
        system"clear"
        puts "Do you think you can lift heavier next time you perform #{@selectedExercise["name"]}? (please enter 'can' or 'cannot')"
        @selectedExercise["canAdvance"] = gets.downcase.chomp
        system"clear"
        puts "Fantastic, you have just created an entry for #{@selectedExercise["name"]}"
        File.write('exercises.json', JSON.pretty_generate(@exercisesHash))
        sleep(3)
end

startScreen

