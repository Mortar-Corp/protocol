//rafce
import React from 'react'
import {Card, Button, ListGroup, Row, Col} from "react-bootstrap"

//can pass listing info into this function later
const Listings = () => {
  return (
    <div>
      {/* md is number of cards per row 
      This iteartes through an array of 4 and creates cards for em*/}
      <Row xs={1} md={2} className="g-4 mt-2 mx-2">
        {Array.from({ length: 4 }).map((_, idx) => (
          <Col>
            <Card>
              <Card.Img variant="top" src="" />
              <Card.Body>
                <Card.Title>Card title</Card.Title>
                <Card.Text>
                  Some quick example text to describe the building would go right here. 
                </Card.Text>
                <ListGroup className= "text-center" variant="flush">
                  <ListGroup.Item>Info Category 1</ListGroup.Item>
                  <ListGroup.Item>Info Category 2</ListGroup.Item>
                  <ListGroup.Item>Info Category 3</ListGroup.Item>
                </ListGroup>
                <Button className= "mx-2" variant = "primary">Bid Now</Button>
              </Card.Body>
            </Card>
          </Col>
        ))}
        </Row>
    </div>
  )
}

export default Listings