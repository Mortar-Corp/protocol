import React from 'react'
import {Card, Button} from "react-bootstrap"

const FAQ = () => {
   
  return (
    <div>
        <h1 className = "mt-3 mb-5 text-center">Frequently Asked Questions</h1>
        <Card className="text-center">
            <Card.Header class = "fs-3">What is Mortar?</Card.Header>
            <Card.Body>
              <Card.Text>
                With supporting text below as a natural lead-in to additional content.
              </Card.Text>
            </Card.Body>
        </Card>
        <Card className="text-center">
            <Card.Header class = "fs-3">How does Mortar work?</Card.Header>
            <Card.Body>
              <Card.Text>
                With supporting text below as a natural lead-in to additional content.
              </Card.Text>
            </Card.Body>
        </Card>
    </div>
  )
}

export default FAQ


