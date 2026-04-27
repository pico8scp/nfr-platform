import { fetchProductDetail } from '../../utils/product-detail'

export default defineEventHandler(async (event) => {
  const id = Number(getRouterParam(event, 'id'))

  if (!Number.isFinite(id) || id <= 0) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid product id',
    })
  }

  const detail = await fetchProductDetail(event, id)

  return {
    status: 200,
    msg: 'success',
    data: detail,
  }
})
