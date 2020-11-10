#!/usr/bin/env python

import math
import rospy
from trajectory_msgs.msg import JointTrajectory
from trajectory_msgs.msg import JointTrajectoryPoint
from geometry_msgs.msg import Twist
from opencv_apps.msg import RotatedRectStamped

pub = None
done = False


def send_joint_position():
    pub = rospy.Publisher("/fullbody_controller/command",
                          JointTrajectory, queue_size=1)
    rospy.sleep(1)

    joint_trajectory = JointTrajectory()
    joint_trajectory.header.stamp = rospy.Time.now()
    joint_trajectory.joint_names = ["arm_joint1", "arm_joint2", "arm_joint3",
                                    "arm_joint4", "arm_joint5", "arm_joint6"]
    for i in range(5):
        point = JointTrajectoryPoint()
        point.positions = [math.pi/2, 0, math.pi /
                           4*(i % 2), 0, math.pi/2, math.pi/2]
        point.time_from_start = rospy.Duration(1.0+i)
        joint_trajectory.points.append(point)

    pub.publish(joint_trajectory)

    rospy.sleep(5)


def cb(msg):
    global pub
    global done
    size = msg.rect.size.width * msg.rect.size.height
    rospy.loginfo("rect size: %d\n" % size)
    if (size > 9000):
        if (done == False):
            send_joint_position()
            done = True


if __name__ == '__main__':
    try:
        rospy.init_node("kadai2_2_near", anonymous=True)
        rospy.Subscriber("/camshift/track_box", RotatedRectStamped, cb)
        rospy.spin()
    except rospy.ROSInterruptException:
        pass
