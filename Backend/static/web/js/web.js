// let mybutton = document.getElementById("uparrow");

function topFunction() {
  document.documentElement.scrollTop = 0; 
}

function hambFunction(){
  let ham=document.getElementById("imghamb");
  let bar=document.getElementById("navbar");
  let myham = document.getElementById("hamburg");
  if (myham.style.display=="none") {
    myham.style.display="inline-block";
  } else {
    myham.style.display = "none";
  }
}