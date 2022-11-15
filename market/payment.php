<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();
    if (isset($_POST['pay_skid']) && isset($_POST['pay_pid']) && isset($_POST['pay_amount']) && isset($_POST['pay_startdate'])) {
        $query_skid = $db->real_escape_string($_POST['pay_skid']);
        $query_pid = $db->real_escape_string($_POST['pay_pid']);
        $query_amount = $db->real_escape_string($_POST['pay_amount']);
        $query_startdate = $db->real_escape_string($_POST['pay_startdate']);

        if($query_amount < 0){
            $_SESSION['payment_failed2'] = 'Amount cannot be negative, Please Retry!!';
            header('Location: payment.php');
            return;
        }

        $query = "INSERT INTO Payment (Amount, PID, SKID, Start_Date) values ($query_amount, $query_pid, $query_skid, '$query_startdate')";
        if($db -> query($query)){
?>
        <div class="modal-content">
			<div class="modal-header">	
				<h4 class="modal-title w-100">Success!</h4>	
			</div>
			<div class="modal-body">
				<p class="text-center">Your Payment is Successfully Registered!!</p>
			</div>
			<div class="modal-footer">
				<a href="home_market.php" class="btn btn-success btn-block" data-dismiss="modal">Home Market Page</a>
			</div>
		</div>
<?php
        }
        else{
            $_SESSION['payment_failed'] = 'Payment Failed, Please Retry!!';
            header('Location: payment.php');
        }
        return;
    }
?>

<div class="signup-form jumbotron vertical-center">
<form method="post">
<center><h2>Payment</h2></center>
<?php
    if (isset($_SESSION['payment_failed'])) {
        echo('<center><p style="color:red">'.$_SESSION['payment_failed'].'</p></center>'."\n");
        unset($_SESSION['payment_failed']);
    }
    if (isset($_SESSION['payment_failed2'])) {
        echo('<center><p style="color:red">'.$_SESSION['payment_failed2'].'</p></center>'."\n");
        unset($_SESSION['payment_failed2']);
    }
?>
<p class="hint-text"></p>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="pay_skid" placeholder="ShopKeeper ID" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="pay_pid" placeholder="Plot ID" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="pay_startdate" placeholder="Start Date" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <input type="text" class="form-control" name="pay_amount" placeholder="Amount" required="required">
    </div>
</div>
<div class="row align-items-center justify-content-center">
    <div class="form-group col-lg-3">
        <button type="submit" class="btn btn-success btn-lg btn-block">Submit</button>
    </div>
</div>
</form>
    <div class="text-center">Cancel Payment? <a href="home_market.php">Go Back</a></div>
</div>