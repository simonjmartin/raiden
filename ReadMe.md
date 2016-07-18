# Solution Builder

This repo has the following branches:

## master
This is a simple, basic solution with one project and a test project.  It is configured to use Moq and XUnit for unit testing.

## SOA
This is a standard solution for the Service Oriented Architecture pattern.

### DomainObjects
Objects used to pass messages between layers in this application.  Keeping DO here stops the abstractions leaking from the other layers in the system. 

### Definitions
Where interfaces are defined.  Keeping them separate allows a layer to have full access to all it needs to know about other parts of the system *without* being able to call those parts directly.

### IoC
Used to wire up which interfaces should be used for which object.

### Services
Services represent a complete suite to a consumer.  They do not reveal their internal workings or business logic, eg "AddNewUser" might touch multiple databases, systems and providers but to a consumer it is just a single call.

A service orchestrates systems to offer complete suites to consumers.

Services are also a sensible place to set security, logging and caching so that they will be available regardless of consumer.

### Systems
Systems represent other places that must be managed to solve problems.  Databases, webservices etc. are all separate systems.  A service will orchestrate them together to solve a problem.

## Getting started

Run ```configurator.ps1``` to configure this solution based on your desired solution name and other attributes.  You will need to have ```git``` installed and available in your path.

## Solution structure

### Build
   Files necessary to support building the project go in here.

   XUnit execution configuration on the build server as also set here.

### Product
#### Production
All the projects that make up the finished product go in here.

*Examples*

 * MyProject.DomainObjects
 * MyProject.Services
 * MyProject.Systems
 * MyProject.Definitions
 * MyProject.IoC

#### Tests
Tertiary projects that support testing the product go in here.

*Examples*

  * MyProject.Tests
  * MyProject.IntegrationTests

### ThirdParty
#### Documents
Code diagrams (DGML) and other supporting documents go here.

#### FxCop
FxCop project is here

#### SQL
Supporting SQL scripts go in here.

*Examples*

  * Test data generation scripts
  * Schema creation scripts

#### StyleCop
StyleCop rules set is here.