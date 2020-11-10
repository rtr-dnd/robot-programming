#!/usr/bin/env roseus
;;;
;;; euslisp version of ros_tutorials/rospy_tutorials/001_talker_listener
;;;

(ros::roseus-add-msgs "trajectory_msgs")

(ros::roseus "kadai3-robotarm" :anonymous t)
(ros::advertise "/fullbody_controller/command" trajectory_msgs::JointTrajectory  1)
(ros::duration-sleep 1)
(let ((joint-trajectory 
        (instance trajectory_msgs::JointTrajectory :init)))
  (send joint-trajectory :header :stamp (ros::time-now))
  (send joint-trajectory :joint_names (list 
    'arm_joint1 'arm_joint2 'arm_joint3 'arm_joint4 'arm_joint5 'arm_joint6
  ))
  (do ((i 0 (+ i 1)))
    ((> i 5))
    (let ((point (instance trajectory_msgs::JointTrajectoryPoint :init)))
      (send point :positions (list
        (/ pi 2)
        0
        (* (/ pi 4) (mod i 2))
        0
        (/ pi 2)
        (/ pi 2)
      ))
      (send point :time_from_start (instance ros::duration :init (+ i 1)))
      (send joint-trajectory :points
        (reverse (cons point (reverse (send joint-trajectory :points)))))
    )
  )
  (print (send joint-trajectory :points))
  (ros::publish "/fullbody_controller/command" joint-trajectory)
  (print joint-trajectory)
  (ros::duration-sleep 5)
)