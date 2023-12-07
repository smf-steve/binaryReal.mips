COMMITS=$(shell git log --oneline | wc -l)
MIN_COMMITS=20
SHELL=/bin/bash

J_SRC=bits2int.j get_bit.j glyph2int.j nextInt.j
S_SRC=bits2int.s get_bit.s glyph2int.s nextInt.s


ARG_CASE1=2
INPUT_CASE1="010100"
RESULT_CASE1="20"

ARG_CASE2=4
INPUT_CASE2="010100"
RESULT_CASE2="272"

ARG_CASE3=16
INPUT_CASE3="2FAA"
RESULT_CASE3="12202"

ARG_CASE4=10
INPUT_CASE4="253FAA"
RESULT_CASE4="253"


test: tags number_commits
	@echo 
	@echo \"make test_java\" to test your current version of nextInt.j
	@echo \"make test_mips\" to test your current version of nextInt.s
	@echo \"make final\" to test all your final versions of nextInt.\*
	@echo \"make validate\" to validate your final submission

test_java: nextInt.j
	echo $(INPUT_CASE1) | java_subroutine nextInt $(ARG_CASE1)
	@echo "Correct answer: " $(RESULT_CASE1)
	@echo
	echo $(INPUT_CASE2) | java_subroutine nextInt $(ARG_CASE2)
	@echo "Correct answer: " $(RESULT_CASE2)
	@echo
	echo $(INPUT_CASE3) | java_subroutine nextInt $(ARG_CASE3)
	@echo "Correct answer: " $(RESULT_CASE3)
	@echo
	echo $(INPUT_CASE4) | java_subroutine nextInt $(ARG_CASE4)
	@echo "Correct answer: " $(RESULT_CASE4)
	@echo

test_mips: nextInt.s
	echo $(INPUT_CASE1) | mips_subroutine nextInt $(ARG_CASE1)
	@echo "Correct answer: " $(RESULT_CASE1)
	@echo
	echo $(INPUT_CASE2) | mips_subroutine nextInt $(ARG_CASE2)
	@echo "Correct answer: " $(RESULT_CASE2)
	@echo
	echo $(INPUT_CASE3) | mips_subroutine nextInt $(ARG_CASE3)
	@echo "Correct answer: " $(RESULT_CASE3)
	@echo
	echo $(INPUT_CASE4) | mips_subroutine nextInt $(ARG_CASE4)
	@echo "Correct answer: " $(RESULT_CASE4)
	@echo


final: final_java_code final_java_tac_code final_mips_code
	git checkout main


final_java_code:
	@git checkout java_code 2> /dev/null || { echo "Error 'java_code' tag not in place" ; false ; }
	make test_java
	git checkout main

final_java_tac_code:
	@git checkout java_tac_code 2> /dev/null || { echo "Error 'java_tac_code' tag not in place" ; false ; }
	make test_java
	git checkout main


final_mips_code:
	@git checkout mips_code  2> /dev/null || { echo "Error 'mips_code' tag not in place" ; false ; }
	make test_mips
	git checkout main



validate: tags number_commits
	-make -k final > validation.tmp 2>&1
	-mv validation.tmp validation.output
	-git add validation.output
	-git commit -m 'Auto adding validation step' validation.output
	@echo Validation File has been committed if there were changes





# Currently, the number of commits does not work on the server side
# the log file only shows the most recent entry -- 
# not sure why or what the work around is.
number_commits:
	@-test ! $(COMMITS) -lt $(MIN_COMMITS) || \
	  { echo You need a minimum of $(MIN_COMMITS) commits && false ; } 

tags:
	@-git tag | grep -q -e "java_code"      || echo "Missing java_code tag"
	@-git tag | grep -q -e "java_tac_code"  || echo "Missing java_tac_code tag"
	@-git tag | grep -q -e "mips_code"      || echo "Missing mips_code tag"



#  The following section is the code the prof will use to determine
#    - what he will and what he will not grade.
#  This section is left here for transparency.
#  His criteria for grading for a particular assignment may change!
#
#  At very most, he will grade 
#    - only material that is submitted by the due_date
#      * unless prior arrangements have been made
#    - a task based upon the point in time in which you asserted is done
#      * by virtue of appropriate tagging

# Create a set of "list of students" to be graded based upon a set of criteria
pre_grade:
	bash -lc 'checkout_due_date'
	bash -lc 'meets_criteria "git tag --list java_code --merged     | grep java_code" '     | sort >criteria_task_1
	bash -lc 'meets_criteria "git tag --list java_tac_code --merged | grep java_tac_code" ' | sort >criteria_task_2
	bash -lc 'meets_criteria "git tag --list mips_code --merged     | grep java_mips_code"' | sort >criteria_task_3
	bash -lc 'meets_criteria "ls validation.output" ' | sort >criteria_validate
	sort ${CLASS_ROSTER} > master_list
	comm -23 master_list criteria_task_1       > No_Criteria_met
	comm -23 criteria_task_1 criteria_task_2   > task_1_complete
	comm -23 criteria_task_2 criteria_task_3   > task_2_complete
	comm -23 criteria_task_3 criteria_validate > task_3_complete

# Use the TO_GRADE variable to restate what to grade
grade: $(TO_GRADE)

grade_all: grade_java_code grade_java_tac_code grade_mips_code grade_validation

grade_java_code: final_java_code
	cp nextInt.j nextInt.java
	subl nextInt.java
	subl grade.report
	git checkout main

grade_java_tac_code: grade_java_code final_java_tac_code
	git checkout java_tac_code
	subl nextInt.j
	git checkout main

grade_mips_code: grade_java_tac_code final_mips_code
	subl nextInt.s
	git checkout main

grade_validate: grade_mips_code
	git checkout grading_information
	subl validation.output
	git checkout main

