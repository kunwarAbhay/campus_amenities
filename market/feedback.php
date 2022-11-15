<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();
    if (isset($_POST['feedback_skid']) && isset($_POST['feedback_pid']) && isset($_POST['feedback_startdate']) && isset($_POST['feedback_cid'])
        && isset($_POST['feedback']) && isset($_POST['feedback_rating'])) {
        $query_skid = $db->real_escape_string($_POST['feedback_skid']);
        $query_pid = $db->real_escape_string($_POST['feedback_pid']);
        $query_startdate = $db->real_escape_string($_POST['feedback_startdate']);
        $query_cid = $db->real_escape_string($_POST['feedback_cid']);
        $query_feedback = $db->real_escape_string($_POST['feedback']);
        $query_feedback_rating = $db->real_escape_string($_POST['feedback_rating']);

        $query = "INSERT INTO Feedback (Start_Date, PID, SKID, CID, Feedback, Rating) values ('$query_startdate', $query_pid, $query_skid, 
                 $query_cid, '$query_feedback', $query_feedback_rating)" ;
        if($db -> query($query)){
?>
        <div class="modal-content">
			<div class="modal-header">	
				<h4 class="modal-title w-100">Success!</h4>	
			</div>
			<div class="modal-body">
				<p class="text-center">Your feedback is registered!!</p>
			</div>
			<div class="modal-footer">
				<a href="home_market.php" class="btn btn-success btn-block" data-dismiss="modal">Home Market Page</a>
			</div>
		</div>
<?php
        }
        else{
            $_SESSION['feedback_failed'] = 'Feedback Failed, Please Retry!!';
            header('Location: feedback.php');
        }
        return;
    }
?>

<div class="signup-form jumbotron vertical-center">
<form method="post">
<center><h2>Feedback</h2></center>
<?php
    if (isset($_SESSION['feedback_failed'])) {
        echo('<center><p style="color:red">'.$_SESSION['feedback_failed'].'</p></center>'."\n");
        unset($_SESSION['feedback_failed']);
    }
?>
<p class="hint-text"></p>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="feedback_skid" placeholder="ShopKeeper ID" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="feedback_pid" placeholder="Plot ID" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="feedback_startdate" placeholder="Start Date" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="feedback_cid" placeholder="Customer ID" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="feedback" placeholder="Feedback" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="feedback_rating" placeholder="Rating (Out of 5)" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <button type="submit" class="btn btn-success btn-lg btn-block">Submit</button>
    </div>
</div>
</form>
    <div class="text-center">Cancel Feedback? <a href="home_market.php">Go Back</a></div>
</div>