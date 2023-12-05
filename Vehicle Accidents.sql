--Ouestion1: How many accidents have occured in urban areas versus rural areas?
Select Area , Count(AccidentIndex) as TotalAccident 
From dbo.accident
Group By Area;

--Ouestion2 : Which day of the week has the highest number of accidents?
Select a.Day, Count(AccidentIndex) as TotalAccident 
From dbo.accident a
Group By a.Day
Order By Count(AccidentIndex) desc

--Ouestion3 : What is the average age of vehicles involved in accidents based on their types?
Select VehicleType, AVG(AgeVehicle) as AvgAgeVehicle
From [dbo].[vehicle]
Where AgeVehicle is Not Null
Group By VehicleType 

--Ouestion4 : Can we identify any trends based on the age of vehicles involved?
Select AgeGroup, Avg(AgeVehicle) as AvgAgeVehicle, COUNT(AccidentIndex) as TotalAccident 
From (
Select  AccidentIndex, AgeVehicle,
	Case
		When AgeVehicle  between 0 and 5 Then 'New'
		When AgeVehicle between 6 and 10 Then 'Regular'
		Else 'Old'
		End as AgeGroup
From dbo.vehicle
) as SubQuery
Group By AgeGroup 

--Question5 : Are there any specific weather conditions that contribute to the severe accidents?
Select Count(AccidentIndex) as TotalAccidents , WeatherConditions , Severity
From dbo.accident
Group By WeatherConditions , Severity
Order By TotalAccidents

--Question6 : Do Accidents often involve impacts on left side of the vehicle?
Select Count(AccidentIndex) as TotalAccident, LeftHand
From dbo.vehicle
Where LeftHand is Not Null
Group By LeftHand

--Question7: Are there any relationship between  journey purpose and severity of the accidents?
Select Count(a.AccidentIndex)as TotalAccidents, v.JourneyPurpose , a.Severity
From dbo.accident a Join dbo.vehicle v
On a.AccidentIndex = v.AccidentIndex
Group By v.JourneyPurpose , a.Severity

--Question8 : Calculate the average age of vehicle involved in accidents considering day light and point of impact?
Select Avg(v.AgeVehicle) as AvgAgeVehicle, v.PointImpact , a.LightConditions
From dbo.accident a Join dbo.vehicle v
On a.AccidentIndex = v.AccidentIndex
Group By v.PointImpact, a.LightConditions
Having LightConditions = 'DayLight'