Select *
From PortfolioProject.dbo.NashvilleHousing


--Populate Property Address Data Where Null


Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by PropertyAddress

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


--PropertyAddress Split Property Address into Street, City 


Select
PARSENAME(REPLACE(PropertyAddress, ',','.'),2)
,PARSENAME(REPLACE(PropertyAddress, ',','.'),1)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertyStreetAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertyStreetAddress = PARSENAME(REPLACE(PropertyAddress, ',','.'),2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertyCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertyCity = PARSENAME(REPLACE(PropertyAddress, ',','.'),1)

Select *
From PortfolioProject.dbo.NashvilleHousing


--Change "SoldAsVacant" values to Yes or No


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = '1' then 'Y'
	   When SoldAsVacant = '0' then 'N'
  END
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SoldAsVacantYN Varchar;

Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacantYN = CASE When SoldAsVacant = '1' then 'Y'
						  When SoldAsVacant = '0' then 'N'
END


-- Identify duplicate rows

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
/*Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress*/

--Delete Duplicates

DELETE
From RowNumCTE
Where row_num > 1
