#!/usr/bin/env roseus
;;;
;;; euslisp version of ros_tutorials/rospy_tutorials/001_talker_listener
;;;

(ros::roseus-add-msgs "actionlib_tutorials")
(ros::roseus-add-msgs "move_base_msgs")

(ros::roseus "kadai2-actionlib" :anonymous t)
(let ((goal 0))
  (if (not (boundp '*c*))
    (setq *c* (instance ros::simple-action-client :init
      "move_base" move_base_msgs::MoveBaseAction)) 
  )
  (send *c* :wait-for-server)
  (setq goal (instance move_base_msgs::MoveBaseGoal :init))
  (send (send (send goal :target_pose) :header) :stamp (ros::time-now))
  (send (send (send goal :target_pose) :header) :frame_id "map")
  (send (send (send (send goal :target_pose) :pose) :position) :x 34)
  (send (send (send (send goal :target_pose) :pose) :position) :x 32)
  (send (send (send (send goal :target_pose) :pose) :orientation) :w 1)
  (print "send goal")
  (print goal)
  (send *c* :send-goal goal)
  (print "wait for goal...")
  (send *c* :wait-for-result)
  (print "done")
)