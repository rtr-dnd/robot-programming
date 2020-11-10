#!/usr/bin/env roseus
;;;
;;; euslisp version of ros_tutorials/rospy_tutorials/001_talker_listener
;;;
(ros::roseus-add-msgs "opencv_apps")
(ros::roseus-add-msgs "geometry_msgs")

(ros::roseus "kadai1-rotate" :anonymous t)
(ros::advertise "/cmd_vel" geometry_msgs::Twist 1)

;; callback function
(defun cb (msg)
  (setq cmd_vel (instance geometry_msgs::Twist :init))
  (let 
    (
      (size (* 
        (send (send (send msg :rect) :size) :width)
        (send (send (send msg :rect) :size) :height)
      ))
      (z 0)
    )
    ; (print (send (send (send msg :rect) :size) :width))
    (print size)
    (if (< size 50000) 
      (if (> (send msg :rect :center :x) 340)
        (setq z -0.5)
        (if (> (send (send (send msg :rect) :center) :x) 340)
          (setq z 0.5)
        )
      )
    )
    (if (= size 0.0)
      (setq z 0.5)
    )
    (print z)
    (send (send cmd_vel :angular) :z z)
    (ros::publish "/cmd_vel" cmd_vel)
  )
)

(ros::subscribe "/camshift/track_box" opencv_apps::RotatedRectStamped #'cb)
(ros::spin)
(exit) 