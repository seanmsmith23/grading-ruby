require 'json'
require 'awesome_print'

def parse(filepath)
  opened = File.open(filepath)
  read = File.read(opened)
  JSON.parse(read)
end

def check_grades_for_decline(grades)
  status = []
  grades.each_with_index do |grade, index|
    if index != 0
      status << grade_change(grades, index, grade)
    end
  end
  status
end

def grade_change(grades, index, grade)
    if grades[index-1] > grade
      :down
    elsif grades[index-1] < grade
      :up
    elsif grades[index-1] > grade
      :even
    end
end

def check_student_progress(student_grades)
  progress = {}
  student_grades.each do |student, grades|
    progress[student] = check_grades_for_decline(grades)
  end
  progress
end


def in_decline?(progress)
  if score_changes(progress) >= 3
    true
  else
    false
  end
end

def score_changes(progress)
  score = 0
  x = 0
  until x == progress.count
    if progress[x] == :up
      score = 0
    elsif progress[x] == :down
      score += 1
    end
    x += 1
  end
  score
end

def students_in_decline(student_progress)
  class_status = {decline: 0, not_in_decline: 0}

  student_progress.each do |student, progress|
    if in_decline?(progress)
      class_status[:decline] += 1
    else
      class_status[:not_in_decline] += 1
    end
  end

  class_status
end

def classroom_progress(filepath)
  data = parse(filepath)
  progress = check_student_progress(data)
  status = students_in_decline(progress)
  p "Students in decline: #{status[:decline]}"
  p "Students NOT in decline: #{status[:not_in_decline]}"
end

classroom_progress('/Users/seansmith/gSchoolWork/warmups/grading-ruby/data/grades.json')