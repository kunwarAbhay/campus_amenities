<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();
    if (isset($_POST['booking_submited'])) {
        $query_name= $db->real_escape_string($_POST['booking_name']);
        $query_sex = $db->real_escape_string($_POST['booking_sex']);
        $query_mobile = $db->real_escape_string($_POST['booking_mobile']);
        $query_email = $db->real_escape_string($_POST['booking_email']);
        $query_designation = $db->real_escape_string($_POST['booking_designation']);
        $query_street_address = $db->real_escape_string($_POST['booking_street_address']);
        $query_city = $db->real_escape_string($_POST['booking_city']);
        $query_state = $db->real_escape_string($_POST['booking_state']);
        $query_pincode = $db->real_escape_string($_POST['booking_pincode']);
        $query_rid = $db->real_escape_string($_POST['booking_rid']);
        $query_doa = $db->real_escape_string($_POST['booking_doa']);
        $query_dod = $db->real_escape_string($_POST['booking_dod']);

        $query = "SELECT RID FROM Room WHERE isAvailable = 'T' and RID = $query_rid" ;
        $res = $db -> query($query);
        
        if(!($res->num_rows)){
            $_SESSION['booking_failed_room'] = 'Booking Request Failed (Room is Unavailable), Please Retry!!';
            header('Location: new_booking.php');
            return;
        }

        $query = "INSERT INTO GUEST (Name, Sex, Mobile, Email, Designation, Street_Address, City, State, Pincode)
                  values ('$query_name', '$query_sex',  $query_mobile, '$query_email', '$query_designation', '$query_street_address', 
                  '$query_city', '$query_state', '$query_pincode')" ;
        if($db -> query($query)){
            $query = "SELECT GID FROM GUEST WHERE GID = (SELECT MAX(GID) FROM GUEST)";
            $res = $db -> query($query);
            $row = $res -> fetch_row();

            $query = "INSERT INTO BOOKINGS values ($query_rid, $row[0], '$query_doa', '$query_dod')" ;
            if(!($db -> query($query))){
                $query = "DELETE FROM GUEST WHERE GID = $row[0]";
                $res = $db -> query($query);
                $_SESSION['booking_failed'] = 'Booking Request Failed, Please Retry!!';
                header('Location: new_booking.php');
                return;
            }
?>
        <div class="modal-content">
			<div class="modal-header">	
				<h4 class="modal-title w-100">Success!</h4>	
			</div>
			<div class="modal-body">
				<p class="text-center">Your room is successfully booked!!</p>
			</div>
			<div class="modal-footer">
				<a href="home_guest_house.php" class="btn btn-success btn-block" data-dismiss="modal">Home Guest House Page</a>
			</div>
		</div>
<?php
        }
        else{
            $_SESSION['booking_failed'] = 'Booking Request Failed, Please Retry!!';
            header('Location: new_booking.php');
        }
        return;
    }
?>

<div class="signup-form jumbotron vertical-center">
<form method="post">
<center><h2>New Booking</h2></center>
<?php
    if (isset($_SESSION['booking_failed'])) {
        echo('<center><p style="color:red">'.$_SESSION['booking_failed'].'</p></center>'."\n");
        unset($_SESSION['booking_failed']);
    }
    if (isset($_SESSION['booking_failed_room'])) {
        echo('<center><p style="color:red">'.$_SESSION['booking_failed_room'].'</p></center>'."\n");
        unset($_SESSION['booking_failed_room']);
    }
?>
<p class="hint-text"></p>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_name" placeholder="Name" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_sex" placeholder="Sex" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_mobile" placeholder="Mobile" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_email" placeholder="Email" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_designation" placeholder="Designation" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_street_address" placeholder="Street Address" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_city" placeholder="City" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_state" placeholder="State" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_pincode" placeholder="Pincode" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_rid" placeholder="Room ID" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_doa" placeholder="Date of Arrival" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="booking_dod" placeholder="Date of Departure" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <button type="submit" class="btn btn-success btn-lg btn-block" name="booking_submited">Submit</button>
    </div>
</div>
</form>
    <div class="text-center">Cancel Booking? <a href="home_guest_house.php">Go Back</a></div>
</div>