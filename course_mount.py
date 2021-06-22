from subprocess import PIPE, run, STDOUT
import sys

courses = [
    "Linux_course/Linux_course1",
    "Linux_course/Linux_course2",
    "machinelearning/ml1",
    "machinelearning/ml2",
    "SQL1",
    "SQL2",
    "SQL3"
]


def usage():
    print("Usage:")
    print("\t./course_mount.py -h To print this help message")
    print("\t./course_mount.py -m -c [course] For mounting a given course")
    print("\t./course_mount.py -u -c [course] For unmounting a given course")
    print("If course name is ommited all courses will be (un)mounted")


def check_mount(file):
    res = run(['mountpoint', '/home/trainee/courses/'+file],
              stdin=PIPE, stdout=PIPE, stderr=STDOUT, text=True)

    return (1-res.returncode)
    # 0 for Not Mount, 1 for Mount


def mount_course(file):
    if(file in courses):
        if(check_mount(file)):
            print(f"{file} Mount Already Exists.")
        else:
            run(['sudo', 'mkdir', '-p', '/home/trainee/courses/'+file],
                stdin=PIPE, stdout=PIPE, stderr=STDOUT, text=True)
            bind = run(['sudo', 'bindfs', '-p', '550', '-u', 'trainee', '-g', 'ftpaccess', '/data/courses/'+file, '/home/trainee/courses/'+file],
                       stdin=PIPE, stdout=PIPE, stderr=STDOUT, text=True)
            if(bind.returncode == 0):
                print(f"Mounted {file}")
            else:
                print("Some Error Occured.")
    else:
        print("Course Not Found!")


def mount_all():
    for course in courses:
        mount_course(course)


def unmount_course(file):
    if(check_mount(file)):
        unbind = run(['sudo', 'umount', '/home/trainee/courses/'+file],
                     stdin=PIPE, stdout=PIPE, stderr=STDOUT, text=True)
        if(unbind.returncode == 0):
            run(['sudo', 'rm', '-rf', '/home/trainee/courses/'+file],
                stdin=PIPE, stdout=PIPE, stderr=STDOUT, text=True)
            print(f"Unmounted {file}")
        else:
            print("Some Error Occured")

    else:
        print(f"{file} Mount does not Exist.")


def unmount_all():
    for course in courses:
        unmount_course(course)


inputs = sys.argv[1:]

val = inputs[0]
if(val == "-h"):
    usage()
elif(val == "-m"):
    if(len(inputs) == 1):
        mount_all()
    else:
        mount_course(inputs[2])
elif(val == "-u"):
    if(len(inputs) == 1):
        unmount_all()
    else:
        unmount_course(inputs[2])
