import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lat", "lng", "form", "button"]

  connect() {
    console.log("Geolocation controller connected")
  }

  submit(event) {
    // 1. Stop the form from submitting immediately
    event.preventDefault()
    
    // 2. Disable button and change text
    this.buttonTarget.disabled = true
    this.buttonTarget.innerText = "Locating..."

    // 3. Get Location
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          // Success: Fill hidden fields
          this.latTarget.value = position.coords.latitude
          this.lngTarget.value = position.coords.longitude
          
          // Submit the form
          this.buttonTarget.innerText = "Checking In..."
          this.formTarget.requestSubmit()
        },
        (error) => {
          // Error: Alert user and reset button
          alert("We need your location to check in. Please allow location access.")
          this.buttonTarget.disabled = false
          this.buttonTarget.innerText = "Check In Now"
        }
      )
    } else {
      alert("Geolocation is not supported by this browser.")
    }
  }
}