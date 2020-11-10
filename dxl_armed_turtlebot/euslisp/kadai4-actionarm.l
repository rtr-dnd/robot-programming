#!/usr/bin/env roseus
;;;
;;; euslisp version of ros_tutorials/rospy_tutorials/001_talker_listener
;;;

(ros::roseus-add-msgs "trajectory_msgs")

(ros::roseus "kadai4-actionarm" :anonymous t)