--Data Cleaning In SQL


Select *
From PortfolioProject.dbo.NashvilleHousing 





--Standardise SaleDate Format 

Select SaleDate
From PortfolioProject.dbo.[NashvilleHousing ]


Select NewSaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing 

Update PortfolioProject.dbo.NashvilleHousing 
Set SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD NewSaleDate DATE;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET NewSaleDate = CONVERT(DATE, SaleDate);





--Lets Populate the property adress

Select *
From PortfolioProject.dbo.NashvilleHousing 
--Where PropertyAddress is null
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID<>b.UniqueID
Where a.PropertyAddress is null

Update a
Set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID<>b.UniqueID 
Where a.PropertyAddress is null





--Lets Breakdown and seperate the values in the propertyAddress column


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT 
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2) AS PropertyAddressSplit,
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1) AS PropertySplitCity
FROM PortfolioProject.dbo.NashvilleHousing;


--Mistake/ Wrong Query

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress Date;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = Convert (Nvarchar (255),PropertySplitAddress )

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)




--Correct Query

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertyAddressSplit Nvarchar (255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertyAddressSplit = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar (255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)





--Lets Breakdown and seperate the values in the OwnerAddress column


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS NewOwnerAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerState,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerCity
FROM PortfolioProject.dbo.NashvilleHousing;


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD NewOwnerAddress Nvarchar (255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET NewOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerState Nvarchar (255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerCity Nvarchar (255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)





--Lets CHANGE_TRACKING_CURRENT_VERSION the Y and N to Yes and No in the SoldAsVacant Column 

Select SoldAsVacant
From PortfolioProject.dbo.NashvilleHousing


Select Distinct(SoldAsVacant), COUNT (SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
Order By 2 


UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = 
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END




--Lets Remove Duplicates 

With Row_NumCTE AS(
Select *,
ROW_NUMBER() Over (
Partition By ParcelID,
			 PropertyAddress,
			 SaleDate,
			 SalePrice,
			 LegalReference
			 ORDER BY UniqueID) row_num
From PortfolioProject.dbo.NashvilleHousing
)
Delete
From Row_NumCTE
Where row_num >1
--Order By PropertyAddress





--Lets delete unused columns 


Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate




