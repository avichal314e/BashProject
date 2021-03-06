# Create an array which holds list of courses. This should be used to compare if the course name is passed in CLI
courses=(
"Linux_course/Linux_course1"
"Linux_course/Linux_course2"
"machinelearning/ml1"
"machinelearning/ml2"
"SQL1"
"SQL2"
"SQL3"
)


usage(){

	echo "Usage:"
        echo -e '\t' "./course_mount.sh -h To print this help message"
        echo -e '\t' "./course_mount.sh -m -c [course] For mounting a given course"
        echo -e '\t' "./course_mount.sh -u -c [course] For unmounting a given course"
        echo "If course name is ommited all courses will be (un)mounted"
}



#function to check mount exists
check_mount() {
	if mountpoint -q "/home/trainee/courses/$1"; then 
		varia=1
	else
		varia=0
	fi

	# Return 1 if mount exists 0 if not exists
}

#function for mount a course
mount_course() {
	val=$1
	if [[  " ${courses[@]} " =~ " ${val} " ]]; then
		local varia=nothing
        	check_mount $val
        	if [[ $varia -eq 1 ]]; then 
			echo "$val Mount Already Exists."
		else
			sudo mkdir -p /home/trainee/courses/$val 
			sudo bindfs -p 550 -u trainee -g ftpaccess "/data/courses/$val" "/home/trainee/courses/$val"
			echo "Mounted $val"
		fi
    	else
		echo "Course Not Found"
	fi

    # Check if the given course exists in course array
    # Check if the mount is already exists
    # Create directory in target
    # Set permissions
    # Mount the source to target
}

mount_all() {
        for course in "${courses[@]}"
        do
        mount_course "$course"
        done
    # Loop through courses array
    # call mount_course
}



# function for unmount course
unmount_course() {
	val=$1
	local varia=nothing
        check_mount $val
        if [[ $varia -eq 1 ]]; then
        	sudo umount "/home/trainee/courses/$val"
		sudo rm -rf "/home/trainee/courses/$val"
		echo "Unmounted $val"
        else
                echo "$val mount Does not Exists."
        fi           
    # Check if mount exists
    # If mount exists unmount and delete directory in target folder
}

# function for unmount all courses
unmount_all() {
	for course in "${courses[@]}"
        do
        unmount_course "$course"
        done

    # Loop through courses array
    # call unmount_course
}



val=$1
if [[ $val == "-h" ]]
        then
        usage
elif [[ $val == "-m" ]]
        then
        arguments=$#
        if [[ $arguments -lt 2 ]]
                then 
		mount_all
        else
                file=$3
		mount_course $file
                #echo "mounting $file"
        fi
elif [[ $val == '-u' ]]
        then
        arguments=$#
        if [[ $arguments -lt 2 ]]
                then
		unmount_all
        else
                file=$3
		unmount_course $file
                #echo "unmounting $file"
        fi
fi
