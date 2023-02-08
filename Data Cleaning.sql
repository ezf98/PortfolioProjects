Select *
From [Portfolio Project Nash]..Nashville

-- Removing time from SaleDate

Select SaleDate, CONVERT(DATE,SaleDate) as DateOfSale
From [Portfolio Project Nash]..Nashville

Update [Portfolio Project Nash]..Nashville
Set SaleDate = CONVERT(DATE,SaleDate)

Alter Table Nashville
Add SaleDateConv date;

Update [Portfolio Project Nash]..Nashville
Set SaleDateConv = CONVERT(DATE,SaleDate)

Select SaleDateConv 
FROM [Portfolio Project Nash]..Nashville

-- Populate Null Property Address values
Select PropertyAddress
FROM [Portfolio Project Nash]..Nashville
Where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, B.PropertyAddress)
From [Portfolio Project Nash]..Nashville as a
JOIN [Portfolio Project Nash]..Nashville as b
     on a.ParcelID = b.ParcelID
	 AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, B.PropertyAddress)
From [Portfolio Project Nash]..Nashville as a
JOIN [Portfolio Project Nash]..Nashville as b
     on a.ParcelID = b.ParcelID
	 AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

-- Separating the Property address into Individual Columns

Select PropertyAddress
From [Portfolio Project Nash]..Nashville

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From [Portfolio Project Nash]..Nashville


Alter Table Nashville
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio Project Nash]..Nashville
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table Nashville
Add PropertySplitCity Nvarchar(255);

Update [Portfolio Project Nash]..Nashville
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select OwnerAddress
From [Portfolio Project Nash]..Nashville



Select 
PARSENAME(Replace(OwnerAddress, ',', '.'), 1 ),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2 ),
PARSENAME(Replace(OwnerAddress, ',', '.'), 3 )
From [Portfolio Project Nash]..Nashville


Alter Table Nashville
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio Project Nash]..Nashville
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3 )

Alter Table Nashville
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project Nash]..Nashville
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2 )

Alter Table Nashville
Add OwnerSplitState Nvarchar(255);

Update [Portfolio Project Nash]..Nashville
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1 )


-- Making values in Sold As Vacant consistent.

Select Distinct(SoldAsVacant)
From [Portfolio Project Nash]..Nashville

Select SoldAsVacant,
CASE
When SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
From [Portfolio Project Nash]..Nashville

Update Nashville
SET SoldAsVacant = CASE
When SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
END
From [Portfolio Project Nash]..Nashville

-- Dropping columns

Select *
From [Portfolio Project Nash]..Nashville

ALTER Table [Portfolio Project Nash]..Nashville
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate

ALTER Table [Portfolio Project Nash]..Nashville
DROP COLUMN SaleDate
