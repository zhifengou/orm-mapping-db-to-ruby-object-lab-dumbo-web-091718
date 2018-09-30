class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    
    sql=<<-SQL 
            SELECT * FROM students
          SQL
      rows=DB[:conn].execute(sql)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql=<<-SQL 
      SELECT * FROM students WHERE name=?
      SQL
      rows=DB[:conn].execute(sql,name)[0]
      self.new_from_db(rows)
      
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*) FROM STUDENTS where grade = 9;
    SQL
     DB[:conn].execute(sql)
  end
  
    def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12;
    SQL
     DB[:conn].execute(sql)[0]
  end
  
  
  
end
