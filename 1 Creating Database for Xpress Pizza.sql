/* Create Database Xpress Pizza named Xpress*/
--Delete DB if it exists

USE master

IF DB_ID('Xpress') IS NOT NULL			--Check if DB exists     
	DROP DATABASE Xpress
GO

--Create DB

IF DB_ID('Xpress') IS NULL				--Chech if DB does not exist
	CREATE DATABASE Xpress 
GO