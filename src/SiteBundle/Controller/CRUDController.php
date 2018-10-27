<?php

namespace SiteBundle\Controller;

use SiteBundle\Entity\Order;
use Sonata\AdminBundle\Controller\CRUDController as Controller;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class CRUDController extends Controller
{
    /**
     * @param $id
     * @return RedirectResponse
     */
    public function cloneOrderDetailsAction($id)
    {
        /** @var Order $object */
        $object = $this->admin->getSubject();

        if (!$object) {
            throw new NotFoundHttpException(sprintf('unable to find the object with id: %s', $id));
        }

        $clonedOrder = (new Order())
            ->setName($object->getName())
            ->setEmail($object->getEmail())
            ->setPhonenumber($object->getPhonenumber())
            ->setAddress($object->getAddress())
            ->setPostal($object->getPostal())
            ->setComments('');

        $this->admin->create($clonedOrder);

        $this->addFlash('sonata_flash_success', 'Order data successfully cloned into new template Order');

        return new RedirectResponse(
            $this->admin->generateUrl('list')
        );
    }
}
